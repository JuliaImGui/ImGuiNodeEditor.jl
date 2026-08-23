# ImGuiNodeEditor

This package provides a Julia wrapper for
[imgui-node-editor](https://github.com/thedmd/imgui-node-editor) (using
[cimnodes_editor](https://github.com/cimgui/cimnodes_editor)), a node editor
written for [Dear ImGui](https://github.com/ocornut/imgui). This library is
intended to be used with
[CImGui.jl](https://juliaimgui.github.io/ImGuiDocs.jl/cimgui).

Have a look at the [example
script](https://github.com/JuliaImGui/ImGuiNodeEditor.jl/blob/master/examples/node_editor.jl)
to see basic usage of the library. For more advanced usage see the [examples in
the upstream repository](https://github.com/thedmd/imgui-node-editor/tree/master/examples).

We try to match the upstream API as closely as possible so the code there should
be easily translatable to Julia.
