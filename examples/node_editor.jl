import CImGui as ig
import ImGuiNodeEditor as ne
import GLFW, ModernGL

ig.set_backend(:GlfwOpenGL3)

# A live link between two pins. The id types are plain values, so there's nothing
# to free.
struct LinkInfo
    id::ne.LinkId
    input::ne.PinId
    output::ne.PinId
end

# The default bitmap font can only be point-upscaled by the zoom (blocky text),
# whereas the vector default can be re-baked crisply at any size.
function load_font!()
    io = ig.GetIO()
    atlas = unsafe_load(io.Fonts)
    ig.AddFontDefaultVector(atlas)
end

# Lay out a single input pin and a single output pin side by side, with a label.
function pin_row(in_pin, out_pin)
    ne.BeginPin(in_pin, ne.PinKind_Input)
    ig.Text("-> In")
    ne.EndPin()

    ig.SameLine()

    ne.BeginPin(out_pin, ne.PinKind_Output)
    ig.Text("Out ->")
    ne.EndPin()
end

# A point on a node's title, in main-viewport coordinates (what the test engine's
# mouse functions take). Clicking a pin doesn't select the node, hence the title
# rather than the centre. The canvas draws in its own local space, so node
# coordinates have to be converted before they mean anything on screen.
function node_title_pos(node)
    pos = ne.GetNodePosition(node)
    size = ne.GetNodeSize(node)
    title = ne.CanvasToScreen(ig.ImVec2(pos.x + size.x / 2, pos.y + size.y / 4))
    viewport_pos = unsafe_load(ig.GetMainViewport().Pos)
    return ig.ImVec2(title.x - viewport_pos.x, title.y - viewport_pos.y)
end

# QueryNewLink()/QueryDeletedLink() write their results through pointers, so
# they're called with a scratch buffer that's kept alive across the ccall.
function query_new_link(pin_buf)
    found = GC.@preserve pin_buf ne.QueryNewLink(pointer(pin_buf, 1), pointer(pin_buf, 2))
    return (found, pin_buf[1], pin_buf[2])
end

function query_deleted_link(link_buf)
    found = GC.@preserve link_buf ne.QueryDeletedLink(pointer(link_buf, 1))
    return (found, link_buf[1])
end

"""
    node_editor(; engine=nothing, save_settings=true, links=LinkInfo[],
                node_titles=Dict{UInt, ig.ImVec2}(), selected=ne.NodeId[])

The keyword arguments beyond `engine` are only passed explicitly by the test
suite: `save_settings=false` keeps the run reproducible by not persisting the
node positions and view to `NodeEditor.json`, and `links`, `node_titles` and
`selected` expose the editor state that the tests assert on.
"""
function node_editor(; engine=nothing, save_settings=true, links=LinkInfo[],
                     node_titles=Dict{UInt, ig.ImVec2}(), selected=ne.NodeId[])
    ctx = ig.CreateContext()
    load_font!()
    editor = ne.CreateEditor()

    if !save_settings
        config = ne.GetConfig(editor)
        unsafe_store!(config.SettingsFile, C_NULL)
    end

    # Ids are just wrappers around an integer. Node A uses ids 1-3, node B uses
    # ids 4-6.
    nodeA = ne.NodeId(1)
    a_in = ne.PinId(2)
    a_out = ne.PinId(3)
    nodeB = ne.NodeId(4)
    b_in = ne.PinId(5)
    b_out = ne.PinId(6)

    next_link_id = Ref(100)
    first_frame = Ref(true)

    # Scratch buffers that QueryNewLink / QueryDeletedLink write the dragged pin
    # and deleted link ids into each frame.
    pin_buf = Vector{ne.PinId}(undef, 2)
    link_buf = Vector{ne.LinkId}(undef, 1)

    on_exit = () -> ne.DestroyEditor(editor)
    ig.render(ctx; window_title="ImGuiNodeEditor Demo", engine, on_exit) do
        # Make the window fill the whole GLFW window so the node editor canvas
        # has room to work with.
        viewport = ig.GetMainViewport()
        ig.SetNextWindowPos(unsafe_load(viewport.WorkPos))
        ig.SetNextWindowSize(unsafe_load(viewport.WorkSize))
        ig.Begin("Node Editor Window")

        ne.SetCurrentEditor(editor)
        ne.Begin("My Editor")

        # The editor zooms by scaling the canvas draw list, which blurs text baked
        # at the base font size, so match the rasterizer density to the
        # magnification (the reciprocal of GetCurrentZoom(), which returns the
        # view's InvScale).
        #
        # Snapping up to a power of two keeps the bake cache warm: each new density
        # re-rasterizes every visible glyph, so the continuous magnification would
        # re-bake almost every frame while zooming.
        zoom = ne.GetCurrentZoom()
        magnification = zoom > 0 ? 1.0f0 / zoom : 1.0f0
        density = exp2(ceil(log2(max(magnification, 1.0f0))))
        ig.SetFontRasterizerDensity(density)

        # Place the nodes once, then let the user drag them around.
        if first_frame[]
            ne.SetNodePosition(nodeA, (10, 10))
            ne.SetNodePosition(nodeB, (210, 60))
        end

        ne.BeginNode(nodeA)
        ig.Text("Node A")
        pin_row(a_in, a_out)
        ne.EndNode()

        ne.BeginNode(nodeB)
        ig.Text("Node B")
        pin_row(b_in, b_out)
        ne.EndNode()

        node_titles[nodeA.value] = node_title_pos(nodeA)
        node_titles[nodeB.value] = node_title_pos(nodeB)
        ne.GetSelectedNodes!(selected)

        # Draw the links that already exist.
        for link in links
            ne.Link(link.id, link.input, link.output)
        end

        # Handle the user dragging out a new link between two pins.
        if ne.BeginCreate()
            dragging, new_start, new_end = query_new_link(pin_buf)
            # Both pins are valid only once the drag hovers a second pin;
            # AcceptNewItem() returns true on mouse release.
            if dragging && new_start.value != 0 && new_end.value != 0 && ne.AcceptNewItem()
                push!(links, LinkInfo(ne.LinkId(next_link_id[]), new_start, new_end))
                next_link_id[] += 1
            end
        end
        ne.EndCreate()

        # Handle links the user deletes (select a link and press Delete).
        if ne.BeginDelete()
            while true
                found, deleted_link = query_deleted_link(link_buf)
                if !found
                    break
                end
                if ne.AcceptDeletedItem()
                    filter!(l -> l.id.value != deleted_link.value, links)
                end
            end
        end
        ne.EndDelete()

        ne.End()
        # Restore the default density for the regular (unzoomed) UI.
        ig.SetFontRasterizerDensity(1.0f0)

        if first_frame[]
            ne.NavigateToContent(0)
        end
        ne.SetCurrentEditor(C_NULL)

        ig.End()

        first_frame[] = false
    end
end

# Run automatically if the script is launched from the command-line
if !isempty(Base.PROGRAM_FILE)
    node_editor()
end
