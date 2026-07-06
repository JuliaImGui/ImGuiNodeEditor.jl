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

    header, line = split(overload[:location], ':')
    imnodes_editor_version = "master"
    link = "https://github.com/thedmd/imgui-node-editor/blob/$(imnodes_editor_version)/$(header).h#L$(line)"

    docstring *= "\n\n[Upstream link]($link)."

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

    # Figure out what other types should be allowed as arguments. Otherwise
    # users would have to be careful to only pass in e.g. Int32's for ImGuiID,
    # which is quite annoying.
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

    # ImGui always defines type aliases for enum primitive types, and then a
    # separate enum type with a trailing underscore. Here we check if such an
    # enum type exists and add it to the union if so.
    enum_type = Symbol(parsed_type, :_)
    try
        # Note that we have to use getproperty() and catch an exception because
        # `bindings_module` is an anonymous module, for which propertynames()
        # doesn't work as usual.
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
        # Strings are complicated. Usually we want to pass String objects but
        # sometimes it's also desirable to pass C_NULL. For this reason we try
        # to allow passing a Ptr{Cvoid} to a string argument when possible, but
        # that can cause method ambiguities when one overload takes in a string
        # and the other takes in a pointer. The second will be given a
        # PtrOrRef{T} type which is a type union that includes Ptr{Cvoid}, so if
        # the string overload also allows taking in a Ptr{Cvoid} we might get a
        # method ambiguity.
        #
        # To avoid this we check the types of the arguments in all the overloads
        # with the same name and position. If any of them are non-string
        # pointers we forbid passing a Ptr{Cvoid} to the string overload.
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
    else
        error("Unsupported C type: '$(type_str)'")
    end

    return if is_ptr
        # If this argument is the only one that has a different type from the
        # other arguments across all the overloads, and the other overloads all
        # have pointers for this argument too, then we can't allow Ptr{Cvoid}
        # because of method ambiguity.
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

    # Filter out variadic arguments. These are always related to string
    # formatting and it's simpler to let that be done in Julia by the users.
    arg_names = filter(!=(:(va_list...)), func_def[:args])
    arg_types_strs = [func_metadata[:argsT][i][:type] for i in eachindex(arg_names)]

    args = copy(arg_names)

    for i in eachindex(args)
        arg_type_str = arg_types_strs[i]

        # If this is the `self` argument and this function belongs to a struct,
        # then it must be the self object.
        if arg_names[i] == :self && func_metadata[:stname] != ""
            args[i] = :($(args[i])::Ptr{$(Symbol(func_metadata[:stname]))})
        elseif arg_type_str == "StyleVar"
            args[i] = :($(args[i])::StyleVar)
        elseif arg_type_str in ("PinId", "PinId*")
            args[i] = :($(args[i])::Ptr{PinId})
        elseif arg_type_str in ("NodeId", "NodeId*")
            args[i] = :($(args[i])::Ptr{NodeId})
        elseif (with_arg_types
                # We don't support parsing array types yet
                || (contains(arg_type_str, "Im") && !contains(arg_type_str, '[')))
            # Always try to parse arg types if `arg_types` is true, or if it's any non-array ImGui type
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

            default_expr = Meta.parse(default)

            # If the argument is annotated with a concrete `Ptr{T}` but the
            # default is the untyped `C_NULL` (a `Ptr{Cvoid}`), construct the
            # correctly-typed null pointer instead. Otherwise the default-arg
            # method would pass a `Ptr{Cvoid}` into a `Ptr{T}` slot and fail to
            # match its own annotation.
            if default_expr === :C_NULL && Meta.isexpr(args[i], :(::))
                argtype = args[i].args[2]
                if Meta.isexpr(argtype, :curly) && argtype.args[1] === :Ptr
                    default_expr = :($argtype(C_NULL))
                end
            end

            args[i] = Expr(:kw, args[i], default_expr)
        end
    end

    ig_name = Symbol(func_metadata[:funcname])

    # Create the identifier for the wrapper function. If it's a constructor then
    # we need to add the method to the original type in the `lib` submodule to
    # avoid shadowing the *type* in `lib` with the *function* in the top-level
    # module. We also capitalize the name for backwards compatibility with the
    # manually created wrappers.
    capitalized_name = Symbol(uppercasefirst(string(ig_name)))
    new_identifier = get(func_metadata, :constructor, false) ? :(lib.$capitalized_name) : capitalized_name

    func_expr = :($new_identifier($(args...)) = lib.$func_name($(arg_names...)))

    docstring = create_docstring(func_name, func_metadata)

    push!(methods, WrapperMethod(new_identifier, docstring, prettify(func_expr)))
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

"""
Iterate over all the functions in the DAG and create wrapper Expr's for them.
"""
function get_wrappers(dag::ExprDAG)
    methods = WrapperMethod[]
    structs = String[]
    enums = Symbol[]
    imgui_defs = JSON3.read(cimnodes_editor_jll.cimnodes_editor_definitions)

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
                    # Check if this is an overload, in which case the function
                    # name will something like `name_type()` or
                    # `struct_name_type()`. We need to strip the `type` part off
                    # to index into `imgui_defs`.
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
            elseif Meta.isexpr(expr, :struct)# && node.id ∉ struct_ignorelist
                struct_name = string(node.id)
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

    # In newer versions of the cimnodes_editor bindings non-POD-types-that-look-like-POD-types-but-actually-aren't
    # are renamed to have a '_c' underscore. In the generated Julia bindings we
    # rename these back to their old names for the sake of convenience.
    # See: https://github.com/cimgui/cimgui/issues/309
    structs_and_enums = JSON3.read(cimnodes_editor_jll.cimnodes_editor_structs_and_enums)
    nonpod_used = structs_and_enums[:nonPOD_used]
    new2old_names = Dict([Symbol(x, "_c") => x for x in keys(nonpod_used)])

    for node in nodes
        for i in eachindex(node.exprs)
            node.exprs[i] = postwalk(node.exprs[i]) do x
                if x isa Symbol && x in keys(new2old_names)
                    new2old_names[x]
                else
                    x
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

        # Load the bindings into a module so we can inspect them when generating
        # the wrappers.
        global bindings_module = Module()
        @eval bindings_module using cimnodes_editor_jll
        Base.include(bindings_module, options["general"]["output_file_path"])
        bindings_module = @invokelatest bindings_module.lib

        methods, structs, enums = get_wrappers(ctx.dag)
        output_file = joinpath(@__DIR__, "../src/wrapper.jl")
        open(output_file; write=true) do io
            # Write the struct 'typedefs'
            for s in filter(!contains("_"), structs)
                write(io, "const $s = lib.$s\n")
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

            # Manually wrap the constructor / value / destructor helpers that
            # cimgui generates for the opaque non-POD id types
            # (NodeId/PinId/LinkId). These aren't present in the upstream
            # definitions JSON, so get_wrappers() can't pick them up
            # automatically.
            manual_names = String[]
            for type in ("NodeId", "PinId", "LinkId")
                ctor = "ax_NodeEditor_$type"
                write(io, """
                \"\"\"
                    $type(value::Integer)

                Construct an opaque `$type` handle (a `Ptr{$type}`) from an integer id.
                \"\"\"
                $type(value::Integer) = lib.$ctor(value)

                \"\"\"
                    value(id::Ptr{$type})

                Return the integer id backing a `$type` handle.
                \"\"\"
                value(id::Ptr{$type}) = lib.$(ctor)_value(id)

                \"\"\"
                Destructor for `$type`.
                \"\"\"
                Destroy(id::Ptr{$type}) = lib.$(ctor)_destroy(id)

                """)
                append!(manual_names, (type, "value", "Destroy"))
            end

            # Write the methods
            for w in methods
                write(io,
                      """
                      \"\"\"
                      $(w.docstring)
                      \"\"\"
                      """)

                # If the function name is exported from Base then we need to explicitly
                # declare a new function with `function` to avoid warnings on 1.12+.
                if Base.isexported(Base, Symbol(w.name))
                    write(io, "function $(w.name) end\n")
                end

                write(io, string(w.expr), "\n\n")
            end

            # Write the `public` statement
            function_names = unique(vcat([string(w.name) for w in methods], manual_names))
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
