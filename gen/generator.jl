import JSON3
using Clang: Clang
using Clang.Generators
using Clang.JLLEnvs
using CImGuiPack_jll
using cimnodes_editor_jll
using JuliaFormatter: format_file, format_text
using MacroTools: splitdef, prettify, postwalk


"""
This anonymous module contains the raw bindings from Clang.jl.
"""
bindings_module::Module = Module()

# Structs whose fields should have their cimgui '_c' suffix stripped
const field_rename_whitelist = (:NodeId, :PinId, :LinkId)

# Buffer functions mapped to the call yielding how many items are available.
# GetOrderedNodeIds() can't be passed a null buffer, so it uses GetNodeCount().
const buffer_count_sources =
    Dict("ax_NodeEditor_GetSelectedNodes" => :(lib.ax_NodeEditor_GetSelectedNodes(C_NULL, 0)),
         "ax_NodeEditor_GetSelectedLinks" => :(lib.ax_NodeEditor_GetSelectedLinks(C_NULL, 0)),
         "ax_NodeEditor_GetActionContextNodes" => :(lib.ax_NodeEditor_GetActionContextNodes(C_NULL, 0)),
         "ax_NodeEditor_GetActionContextLinks" => :(lib.ax_NodeEditor_GetActionContextLinks(C_NULL, 0)),
         "ax_NodeEditor_GetOrderedNodeIds" => :(lib.ax_NodeEditor_GetNodeCount()))

struct WrapperMethod
    name::Union{Expr, Symbol}
    docstring::String
    expr::Expr
end

function create_docstring(func_name, overload)
    docstring = "\$(TYPEDSIGNATURES)"

    comment = get(overload, :comment, "")
    if !isempty(comment)
        comment = replace(comment, "\\0" => "\\\\0")
        formatted_comment = chopprefix(comment, "//") |> strip |> uppercasefirst
        if !isempty(formatted_comment) && formatted_comment[end] ∉ ('.', '!', '?')
            formatted_comment *= "."
        end

        docstring *= "\n\n$(formatted_comment)"
    end

    if func_name === :ax_NodeEditor_Config_Config_Config
        docstring *= "\n\nThe returned `Config` is heap-allocated, it must be freed with [`Destroy`](@ref)."
    end

    # Synthesized overloads (e.g. the id constructors/accessors) have no location.
    location = get(overload, :location, "")
    if !isempty(location)
        header, line = split(location, ':')
        imnodes_editor_version = "master"
        link = "https://github.com/thedmd/imgui-node-editor/blob/$(imnodes_editor_version)/$(header).h#L$(line)"

        docstring *= "\n\n[Upstream link]($link)."
    end

    return docstring
end

"""
Convert an ImGui argument type to a Julia type annotation.
"""
function imgui_to_jl_type(ig_type)
    parsed_type = Meta.parse(ig_type)
    if !(parsed_type isa Symbol)
        # If it's a whole expression, just return
        return parsed_type
    end

    # Allow other argument types too, so that users don't have to pass e.g.
    # exactly an Int32 for ImGuiID.
    unions = if parsed_type === :ImVec2
        # ImVec2 and ImVec4 have special support for NTuple's
        [:(NTuple{2})]
    elseif parsed_type === :ImVec4
        [:(NTuple{4})]
    elseif @invokelatest(getproperty(bindings_module, parsed_type)) in (Cint, Cuint)
        [:Integer]
    else
        []
    end

    # ImGui pairs each enum primitive alias with a separate enum type suffixed
    # with '_', so add that to the union if it exists.
    enum_type = Symbol(parsed_type, :_)
    try
        # getproperty() + catch, because propertynames() doesn't work as usual
        # on anonymous modules.
        @invokelatest getproperty(bindings_module, enum_type)
        pushfirst!(unions, enum_type)
    catch ex
        if !(ex isa UndefVarError)
            rethrow()
        end
    end

    return if isempty(unions)
        [parsed_type]
    else
        [parsed_type, unions...]
    end
end

"""
For numeric C arguments, widen to the safest possible Julia type so that people
can e.g. pass Int literals to functions that take in a Int32.
"""
function widen_numeric_type(arg_type, overload_arg_types)
    c_numeric_types = Dict("int" => :Int,
                           "unsigned int" => :UInt,
                           "float" => :Float32,
                           "double" => :Float64)
    if arg_type ∉ keys(c_numeric_types)
        error("Cannot widen a non-numeric type")
    end

    check_integral = x -> x in ("int", "unsigned int")
    check_floating = x -> x in ("float", "double")
    is_integral = check_integral(arg_type)
    is_floating = !is_integral
    widest_possible_type = [is_integral ? :Integer : :Real]

    # If the type is the same for all overloads we can widen
    if all(==(arg_type), overload_arg_types)
        return widest_possible_type
    end

    # If this is the only numeric type in all the overloads we can widen
    if !any(x -> x in keys(c_numeric_types), overload_arg_types)
        return widest_possible_type
    end

    # If this is the only integral/floating type in all the overloads we can widen
    if (is_integral && !any(check_integral, overload_arg_types)) || (is_floating && !any(check_floating, overload_arg_types))
        return widest_possible_type
    end

    # Otherwise fall back to the matching C type
    return [c_numeric_types[arg_type]]
end

"""
Convert a C argument type to a Julia type annotation.
"""
function to_jl_type(func_name, func_idx, arg_idx, overloads)
    # Find the type for this argument
    func_args = overloads[func_idx][:argsT]
    arg_info = func_args[arg_idx]
    type_str = arg_info[:type]

    unqualify = x -> replace(x, "const " => "")

    # And the types of the same argument *by name* and *by position* in any other overloads
    arg_name = arg_info[:name]
    overload_arg_types = String[]
    positional_overload_arg_types = String[]
    shares_other_args = false
    for overload_metadata in overloads
        overload_name = Symbol(overload_metadata[:ov_cimguiname])
        if overload_name == func_name
            continue
        end

        # Get the type of the same argument by name
        overload_args = overload_metadata[:argsT]
        idx = findfirst(x -> x[:name] == arg_name, overload_args)
        if !isnothing(idx)
            push!(overload_arg_types, unqualify(overload_args[idx][:type]))
        end

        # Get the type of the same argument by position
        if arg_idx <= length(overload_args)
            push!(positional_overload_arg_types, unqualify(overload_args[arg_idx][:type]))
        end

        # Check if this overload shares the same types with the other arguments
        if length(overload_args) == length(func_args)
            # Get the types of the other args
            func_args_types = String[arg[:type] for (i, arg) in enumerate(func_args) if i != arg_idx]
            overload_args_types = String[arg[:type] for (i, arg) in enumerate(overload_args) if i != arg_idx]

            if func_args_types == overload_args_types
                shares_other_args = true
            end
        end
    end

    # Strip const qualifiers and determine if the arg is a pointer type
    unqualified_type = unqualify(type_str)
    is_ptr = unqualified_type != "char*" && unqualified_type[end] == '*'
    if is_ptr
        unqualified_type = unqualified_type[1:end - 1]
    end

    unions = if startswith(unqualified_type, "Im")
        imgui_to_jl_type(unqualified_type)
    elseif unqualified_type == "bool"
        [:Bool]
    elseif unqualified_type == "int"
        is_ptr ? [:Int32] : widen_numeric_type(unqualified_type, overload_arg_types)
    elseif unqualified_type == "unsigned int"
        is_ptr ? [:UInt32] : widen_numeric_type(unqualified_type, overload_arg_types)
    elseif unqualified_type == "float"
        is_ptr ? [:Float32] : widen_numeric_type(unqualified_type, overload_arg_types)
    elseif unqualified_type == "double"
        is_ptr ? [:Float64] : widen_numeric_type(unqualified_type, overload_arg_types)
    elseif unqualified_type == "char"
        [:Char]
    elseif unqualified_type == "char*"
        # We'd like to allow C_NULL as well as String, but a Ptr{Cvoid} here can
        # be ambiguous with another overload taking a pointer (which is given a
        # PtrOrRef{T}, a union that includes Ptr{Cvoid}). So only allow it if no
        # other overload takes a non-string pointer by the same name or position.
        is_different_ptr = x -> x != unqualified_type && contains(x, "*")
        has_non_string_ptr = (!isnothing(findfirst(is_different_ptr, overload_arg_types))
                              || !isnothing(findfirst(is_different_ptr, positional_overload_arg_types)))

        if has_non_string_ptr
            # Conservative option (only taken if necessary)
            [:String, :(Ptr{Cchar})]
        else
            # Loosest option (preferable)
            [:String, :(Ptr{Cchar}), :(Ptr{Cvoid})]
        end
    elseif unqualified_type == "void"
        [:Cvoid]
    elseif unqualified_type == "size_t"
        [:Int]
    elseif unqualified_type == "uintptr_t"
        is_ptr ? [:UInt] : [:Integer]
    else
        error("Unsupported C type: '$(type_str)'")
    end

    return if is_ptr
        # Ptr{Cvoid} would be ambiguous if this is the only differing argument
        # and the other overloads take a pointer here too.
        correct_ptr_type = shares_other_args ? :PtrOrRef : :VoidablePtrOrRef

        if length(unions) == 1
            :($correct_ptr_type{$(only(unions))})
        else
            ptr_exprs = [:($correct_ptr_type{$T}) for T in unions]
            :(Union{$(ptr_exprs...)})
        end
    else
        if length(unions) == 1
            only(unions)
        else
            :(Union{$(unions...)})
        end
    end
end

"""
Wrap a single cimnodes_editor function.
"""
function wrap_function!(methods, func_name, func_def, overloads; with_arg_types=false)
    func_idx = findfirst(x -> x[:ov_cimguiname] === string(func_name), overloads)
    func_metadata = overloads[func_idx]

    # Variadic args are always string formatting, which is simpler to do in Julia.
    arg_names = filter(!=(:(va_list...)), func_def[:args])
    arg_types_strs = [func_metadata[:argsT][i][:type] for i in eachindex(arg_names)]

    args = copy(arg_names)

    # Constructors are added to the struct type, so their arguments must always be
    # annotated to avoid overwriting Julia's default constructor.
    is_constructor = get(func_metadata, :constructor, false)

    for i in eachindex(args)
        arg_type_str = arg_types_strs[i]

        # `self` may be passed by pointer or by value (e.g. the id accessors).
        if arg_names[i] == :self && func_metadata[:stname] != ""
            self_type = Symbol(func_metadata[:stname])
            args[i] = if endswith(arg_type_str, "*")
                :($(args[i])::Ptr{$self_type})
            else
                :($(args[i])::$self_type)
            end
        elseif arg_type_str == "StyleVar"
            args[i] = :($(args[i])::StyleVar)
        elseif arg_type_str == "PinId"
            args[i] = :($(args[i])::PinId)
        elseif arg_type_str == "NodeId"
            args[i] = :($(args[i])::NodeId)
        elseif arg_type_str in ("PinId*", "NodeId*", "LinkId*")
            args[i] = :($(args[i])::VoidablePtrOrRef{$(Symbol(chopsuffix(arg_type_str, "*")))})
        # elseif arg_type_str == "LinkId"
        #     args[i] = :($(args[i])::LinkId)
        elseif (with_arg_types || is_constructor
                # We don't support parsing array types yet
                || (contains(arg_type_str, "Im") && !contains(arg_type_str, '[')))
            type = to_jl_type(func_name, func_idx, i, overloads)
            args[i] = :($(args[i])::$(type))
        end

        if haskey(func_metadata[:defaults], arg_names[i])
            default = func_metadata[:defaults][arg_names[i]]
            if default in ("NULL", "nullptr")
                default = "C_NULL"
            end

            # Replace all float literals of the form '1f' or '0.0f' etc with '1f0'/'0.0f0'
            default = replace(default, r"\df" => x -> "$(x[1])f0")

            # Rewrite C++ scoped enum values like `FlowDirection::Forward` to the
            # `FlowDirection_Forward` aliases we generate for them. Julia would
            # otherwise parse the `::` as a type assertion.
            default = replace(default, r"(\w+)::(\w+)" => s"\1_\2")

            default_expr = Meta.parse(default)

            # A bare C_NULL wouldn't match a concrete Ptr{T} annotation, so
            # construct a correctly-typed null pointer instead.
            if default_expr === :C_NULL && Meta.isexpr(args[i], :(::))
                argtype = args[i].args[2]
                if Meta.isexpr(argtype, :curly) && argtype.args[1] === :Ptr
                    default_expr = :($argtype(C_NULL))
                end
            end

            args[i] = Expr(:kw, args[i], default_expr)
        end
    end

    stname = func_metadata[:stname]

    # Some member functions (e.g. the id accessors) keep the full C name, so strip
    # the namespace and struct prefixes off it.
    ig_name = chopprefix(func_metadata[:funcname], "ax_NodeEditor_")
    if stname != ""
        ig_name = chopprefix(ig_name, "$(stname)_")
    end

    # Constructors are added to the type in `lib` to avoid shadowing it with a
    # function in the top-level module. Names are capitalized for backwards
    # compatibility with the manually created wrappers.
    capitalized_name = Symbol(uppercasefirst(ig_name))
    new_identifier = if get(func_metadata, :constructor, false)
        :(lib.$(Symbol(stname)))
    else
        capitalized_name
    end

    func_expr = :($new_identifier($(args...)) = lib.$func_name($(arg_names...)))

    docstring = create_docstring(func_name, func_metadata)

    if haskey(buffer_count_sources, string(func_name))
        wrap_buffer_function!(methods, func_name, capitalized_name,
                              Symbol(chopsuffix(arg_types_strs[1], "*")), docstring)
    else
        push!(methods, WrapperMethod(new_identifier, docstring, prettify(func_expr)))
    end
end

"""
Wrap a function that fills a caller-provided buffer of ids. These get a `!`
method that resizes the buffer to fit before filling it, plus an allocating
method that returns a fresh Vector.
"""
function wrap_buffer_function!(methods, func_name, capitalized_name, id_type, docstring)
    bang_name = Symbol(capitalized_name, :!)

    bang_expr = :(function $bang_name(ids::Vector{$id_type})
                      resize!(ids, $(buffer_count_sources[string(func_name)]))
                      lib.$func_name(ids, length(ids))
                      return ids
                  end)
    alloc_expr = :($capitalized_name() = $bang_name($id_type[]))

    push!(methods, WrapperMethod(bang_name, docstring * "\n\n`ids` is resized to fit and returned.",
                                 prettify(bang_expr)))
    push!(methods, WrapperMethod(capitalized_name,
                                 "\$(TYPEDSIGNATURES)\n\nAllocating variant of [`$(bang_name)`](@ref).",
                                 prettify(alloc_expr)))
end

"""
Wrap a destructor. These are pretty simple so we define them separately from
other functions.
"""
function wrap_destructor!(methods, func_name)
    type = Symbol(split(string(func_name), "_")[1])

    func_expr = :(Destroy(self::Ptr{$type}) = lib.$func_name(self))

    push!(methods, WrapperMethod(:Destroy, "Destructor for `$type`", prettify(func_expr)))
end

function get_new2old()
    # Newer cimnodes_editor bindings suffix non-POD-types-that-look-like-POD-types
    # with '_c', so rename them back to their old names.
    # See: https://github.com/cimgui/cimgui/issues/309
    structs_and_enums = JSON3.read(cimnodes_editor_jll.cimnodes_editor_structs_and_enums)
    nonpod_used = structs_and_enums[:nonPOD_used]
    new2old_names = Dict([Symbol(x, "_c") => x for x in keys(nonpod_used)])
end

"""
Iterate over all the functions in the DAG and create wrapper Expr's for them.
"""
function get_wrappers(dag::ExprDAG)
    methods = WrapperMethod[]
    structs = String[]
    enums = Symbol[]
    imgui_defs = JSON3.read(cimnodes_editor_jll.cimnodes_editor_definitions)
    new2old_names = get_new2old()

    for node in dag.nodes
        for (i, expr) in enumerate(node.exprs)
            # If this is a generated function, extract the :function from it
            if Meta.isexpr(expr, :macrocall) && expr.args[1] == Symbol("@generated")
                expr = expr.args[3]
            end

            if Meta.isexpr(expr, :function)
                # Wrap regular functions

                func_def = splitdef(expr)
                func_name = func_def[:name]

                if func_name in keys(imgui_defs) && length(imgui_defs[func_name]) == 1
                    all_overloads = imgui_defs[func_name]
                    func_metadata = only(all_overloads)

                    # Handle destructors specially
                    if haskey(func_metadata, :destructor) && func_metadata[:destructor]
                        wrap_destructor!(methods, func_name)
                        continue
                    end

                    wrap_function!(methods, func_name, func_def, all_overloads)
                else
                    # Overloads are named `name_type()` or `struct_name_type()`, so
                    # strip the `type` suffix off to index into `imgui_defs`.
                    split_name = rsplit(string(func_name), "_"; limit=2)
                    if length(split_name) == 1
                        continue
                    end

                    abstract_name = split_name[1]
                    if !haskey(imgui_defs, abstract_name)
                        # This is very spammy so we don't print a warning by default.
                        # @warn "Skipping '$(func_name)' because it's not in `imgui_defs`"
                        continue
                    end

                    all_overloads = imgui_defs[abstract_name]
                    for overload_metadata in imgui_defs[abstract_name]
                        if overload_metadata[:ov_cimguiname] == string(func_name)
                            try
                                wrap_function!(methods, func_name, func_def, all_overloads; with_arg_types=true)
                            catch ex
                                @warn "Couldn't wrap '$(func_name)'" exception=ex
                            end
                        end
                    end
                end
            elseif Meta.isexpr(expr, :struct)
                struct_name = get(new2old_names, node.id, node.id) |> string
                push!(structs, struct_name)
            elseif Meta.isexpr(expr, :macrocall) && expr.args[1] == Symbol("@cenum")
                push!(enums, node.id)
            end
        end
    end

    return methods, structs, enums
end

function rewrite!(dag)
    # Strip any symbols that aren't from cimnodes_editor.h (e.g. the CImGui
    # symbols pulled in via imgui.h).
    nodes = dag.nodes
    for i in reverse(eachindex(nodes))
        node = nodes[i]

        filename = Clang.get_filename(node.cursor)
        if !endswith(filename, "cimnodes_editor.h")
            popat!(nodes, i)
        end
    end

    new2old_names = get_new2old()

    for node in nodes
        for i in eachindex(node.exprs)
            node.exprs[i] = postwalk(node.exprs[i]) do x
                if x isa Symbol && x in keys(new2old_names)
                    new2old_names[x]
                else
                    x
                end
            end

            # cimgui also suffixes fields that clash with a member function of the
            # same name (e.g. NodeId::value()), so strip those too.
            if Meta.isexpr(node.exprs[i], :struct) && node.exprs[i].args[2] in field_rename_whitelist
                for f in node.exprs[i].args[3].args
                    if Meta.isexpr(f, :(::)) && endswith(string(f.args[1]), "_c")
                        f.args[1] = Symbol(chopsuffix(string(f.args[1]), "_c"))
                    end
                end
            end
        end
    end
end

function generate()
    cd(@__DIR__) do
        include_dir = joinpath(cimnodes_editor_jll.artifact_dir, "include")
        cimgui_include_dir = joinpath(CImGuiPack_jll.artifact_dir, "include")

        header = joinpath(include_dir, "cimnodes_editor.h") |> normpath

        local ctx
        options = load_options(joinpath(@__DIR__, "generator.toml"))
        for target in ("x86_64-linux-gnu",)
            @info "processing $target"

            options["general"]["output_file_path"] = joinpath(@__DIR__, "..", "lib", "$target.jl")

            args = get_default_args()
            push!(args,
                  "-I$include_dir", "-I$(cimgui_include_dir)",
                  "-DCIMGUI_DEFINE_ENUMS_AND_STRUCTS",

                  # Define a dummy override since cimgui_impl.h doesn't define CIMGUI_API
                  "-DCIMGUI_API=;",
                  # cimgui_impl.h uses 'bool', but that requires an extra header
                  "-includestdbool.h")

            ctx = create_context([header], args, options)
            build!(ctx, BUILDSTAGE_NO_PRINTING)
            rewrite!(ctx.dag)
            build!(ctx, BUILDSTAGE_PRINTING_ONLY)
        end

        println()
        @info "Generating wrapper.jl..."
        println()

        # Load the bindings so we can inspect them while generating the wrappers.
        global bindings_module = Module()
        @eval bindings_module using cimnodes_editor_jll
        Base.include(bindings_module, options["general"]["output_file_path"])
        bindings_module = @invokelatest bindings_module.lib

        methods, structs, enums = get_wrappers(ctx.dag)
        output_file = joinpath(@__DIR__, "../src/wrapper.jl")
        open(output_file; write=true) do io
            write(io,
                  """
                  const PtrOrRef{T} = Union{Ptr{T}, Ref{T}} where T
                  const VoidablePtrOrRef{T} = Union{Ptr{T}, Ref{T}, Ptr{Cvoid}} where T

                  """)

            # Write the struct 'typedefs', dropping the cimgui namespace prefix
            @show structs
            for s in structs
                name = chopprefix(s, "cimnodes_editor_")
                if contains(name, "_")
                    continue
                end

                write(io, "const $name = lib.$s\n")
            end
            write(io, "\n")

            # Write enum 'typedefs'
            for e in enums
                x = @invokelatest getproperty(bindings_module, e)

                write(io, "const $(e) = lib.$e\n")
                for inst in @invokelatest instances(x)
                    inst_name = string(@invokelatest Symbol(inst))
                    wrapped_name = startswith(inst_name, string(e)) ? inst_name : "$(e)_$(inst_name)"
                    write(io, "const $wrapped_name = lib.$inst_name\n")
                end
                write(io, "\n")
            end

            # Write the methods
            for w in methods
                write(io,
                      """
                      \"\"\"
                      $(w.docstring)
                      \"\"\"
                      """)

                # Names exported from Base need an explicit declaration to avoid
                # warnings on 1.12+.
                if Base.isexported(Base, Symbol(w.name))
                    write(io, "function $(w.name) end\n")
                end

                write(io, string(w.expr), "\n\n")
            end

            # Write the `public` statement
            function_names = unique([string(w.name) for w in methods])
            # Filter out methods of another module and internal methods
            filter!(x -> !startswith(x, "lib.") && !startswith(x, "_"), function_names)
            function_names = join(function_names, ", ")

            write(io, """
            @static if VERSION >= v"1.11"
                eval(Meta.parse("public $(function_names)"))
            end
            """)
        end

        format_file(output_file; margin=120)
    end

    return nothing
end

# Run automatically if the script is launched from the command-line
if !isempty(Base.PROGRAM_FILE)
    generate()
end
