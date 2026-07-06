using Test

using ImGuiTestEngine
import ImGuiTestEngine as te
import CImGui as ig
import ImGuiNodeEditor as ne

import GLFW
import ModernGL
ig.set_backend(:GlfwOpenGL3)

include(joinpath(@__DIR__, "..", "examples", "node_editor.jl"))

@testset "Simple node editor" begin
    engine = te.CreateContext(; exit_on_completion=true)

    @register_test(engine, "Node editor", "One node") do
        @imcheck GetWindowByRef("Node Editor Window") != C_NULL
    end

    node_editor(; engine)
    te.DestroyContext(engine)
end
