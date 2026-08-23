using Test

import Aqua
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

    node_titles = Dict{UInt, ig.ImVec2}()
    selected = ne.NodeId[]

    @register_test(engine, "Node editor", "One node") do
        @imcheck GetWindowByRef("Node Editor Window") != C_NULL

        # Bring the editor window to the front so that nothing else can steal
        # the clicks below, and let the nodes lay out so that we know where they
        # are on screen.
        te.WindowFocus("Node Editor Window")
        Yield(3)
        @imcheck isempty(selected)
        @imcheck haskey(node_titles, UInt(1))

        # Click node A and check that the editor reports it as selected.
        MouseMoveToPos(node_titles[UInt(1)])
        Yield(2)
        MouseClick(0)
        Yield(3)

        @imcheck length(selected) == 1
        @imcheck selected[1].value == 1
    end

    node_editor(; engine, save_settings=false, node_titles, selected)
    te.DestroyContext(engine)
end

@testset "Node/link queries" begin
    ctx = ig.CreateContext()
    engine = te.CreateContext(; )
    engine_io = te.GetIO(engine)
    engine_io.ConfigRunSpeed = te.RunSpeed_Cinematic
    editor = ne.CreateEditor()

    # Don't let the editor load/save a settings file, otherwise the selections
    # would be saved and interfere with the tests.
    config = ne.GetConfig(editor)
    unsafe_store!(config.SettingsFile, C_NULL)

    nodeA = ne.NodeId(1)
    a_out = ne.PinId(2)
    nodeB = ne.NodeId(3)
    b_in = ne.PinId(4)
    link_id = ne.LinkId(100)

    first_frame = Ref(true)
    select_link = Ref(false)
    clear_selection = Ref(false)
    posA = Ref(ig.ImVec2(0, 0))
    posB = Ref(ig.ImVec2(0, 0))
    found_pins = Ref(false)
    link_pins = Ref((ne.PinId(0), ne.PinId(0)))
    selected_links = Ref(ne.LinkId[])

    t = @register_test(engine, "Node editor", "Node/link queries")
    t.GuiFunc = () -> begin
        ig.Begin("Node Editor Window")
        ne.SetCurrentEditor(editor)
        ne.Begin("Editor")

        if first_frame[]
            ne.SetNodePosition(nodeA, (10, 10))
            ne.SetNodePosition(nodeB, (210, 60))
            first_frame[] = false
        end

        ne.BeginNode(nodeA)
        ig.Text("Node A")
        ne.BeginPin(a_out, ne.PinKind_Output)
        ig.Text("Out ->")
        ne.EndPin()
        ne.EndNode()

        ne.BeginNode(nodeB)
        ig.Text("Node B")
        ne.BeginPin(b_in, ne.PinKind_Input)
        ig.Text("-> In")
        ne.EndPin()
        ne.EndNode()

        ne.Link(link_id, a_out, b_in)

        if select_link[]
            ne.SelectLink(link_id)
            select_link[] = false
        end
        if clear_selection[]
            ne.ClearSelection()
            clear_selection[] = false
        end

        posA[] = ne.GetNodePosition(nodeA)
        posB[] = ne.GetNodePosition(nodeB)

        pin_buf = Vector{ne.PinId}(undef, 2)
        found_pins[] = GC.@preserve pin_buf ne.GetLinkPins(link_id, pointer(pin_buf, 1),
                                                           pointer(pin_buf, 2))
        link_pins[] = (pin_buf[1], pin_buf[2])

        selected_links[] = ne.GetSelectedLinks()

        ne.End()
        ne.SetCurrentEditor(C_NULL)
        ig.End()
    end

    t.TestFunc = () -> begin
        # The link only exists from the second frame, after the first one
        # declared it.
        Yield(2)

        @imcheck posA[].x == 10 && posA[].y == 10
        @imcheck posB[].x == 210 && posB[].y == 60

        @imcheck found_pins[]
        @imcheck link_pins[][1].value == a_out.value
        @imcheck link_pins[][2].value == b_in.value

        @imcheck isempty(selected_links[])

        select_link[] = true
        Yield(2)
        @imcheck length(selected_links[]) == 1
        @imcheck selected_links[][1].value == link_id.value

        clear_selection[] = true
        Yield(2)
        @imcheck isempty(selected_links[])
    end

    ig.render(ctx; engine) do ; end

    ne.DestroyEditor(editor)
    te.Stop(engine)
    te.DestroyContext(engine)
end

@testset "Aqua" begin
    Aqua.test_all(ne)
end
