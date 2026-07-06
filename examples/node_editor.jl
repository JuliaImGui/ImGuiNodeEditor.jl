import CImGui as ig
import ImGuiNodeEditor as ne
import GLFW, ModernGL

ig.set_backend(:GlfwOpenGL3)

# A live link between two pins. Each link carries its own id alongside the input
# and output pins it connects.
mutable struct LinkInfo
    id::Ptr{ne.LinkId}
    input::Ptr{ne.PinId}
    output::Ptr{ne.PinId}
end

# Dear ImGui's built-in default is a fixed-resolution *bitmap* font, so the node
# editor's zoom can only point-upscale it (blocky text). The vector default is a
# TTF that the dynamic font system can re-bake crisply at any zoom.
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

function node_editor(; engine=nothing)
    ctx = ig.CreateContext()
    load_font!()
    editor = ne.CreateEditor()

    # Opaque id handles are created once and reused every frame. Node A uses ids
    # 1-3, node B uses 4-6.
    nodeA = ne.NodeId(1)
    a_in = ne.PinId(2)
    a_out = ne.PinId(3)
    nodeB = ne.NodeId(4)
    b_in = ne.PinId(5)
    b_out = ne.PinId(6)

    links = LinkInfo[]
    next_link_id = Ref(100)
    first_frame = Ref(true)

    # Scratch handles that QueryNewLink / QueryDeletedLink write the dragged pin
    # and deleted link ids into each frame.
    new_start = ne.PinId(0)
    new_end = ne.PinId(0)
    deleted_link = ne.LinkId(0)

    ig.render(ctx; window_title="ImGuiNodeEditor Demo", engine,
              on_exit=() -> ne.DestroyEditor(editor)) do
        # Make the window fill the whole GLFW window so the node editor canvas
        # has room to work with.
        viewport = ig.GetMainViewport()
        ig.SetNextWindowPos(unsafe_load(viewport.WorkPos))
        ig.SetNextWindowSize(unsafe_load(viewport.WorkSize))
        ig.Begin("Node Editor Window")

        ne.SetCurrentEditor(editor)
        ne.Begin("My Editor")

        # The editor zooms by scaling the canvas draw list, which upscales text
        # baked at the base font size and makes it blurry. Dear ImGui 1.92's
        # dynamic font system can re-bake glyphs at a higher pixel density, so
        # match the rasterizer density to the magnification to keep text crisp.
        #
        # GetCurrentZoom() returns the view's InvScale, so the magnification
        # factor is its reciprocal.
        #
        # Snap the density up to the next power of two. A new density value bakes
        # a fresh font atlas entry and re-rasterizes every visible glyph, so
        # using the continuous magnification would re-bake almost every frame
        # while zooming. Quantizing keeps the bake cache warm (a handful of
        # distinct densities) at the cost of slightly over-baking; rounding up
        # rather than down keeps text at least as sharp as the magnification.
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

        # Draw the links that already exist.
        for link in links
            ne.Link(link.id, link.input, link.output)
        end

        # Handle the user dragging out a new link between two pins.
        if ne.BeginCreate()
            if ne.QueryNewLink(new_start, new_end)
                start_val = ne.value(new_start)
                end_val = ne.value(new_end)
                # Both pins are valid only once the drag hovers a second pin;
                # AcceptNewItem() returns true on mouse release.
                if start_val != 0 && end_val != 0 && ne.AcceptNewItem()
                    push!(links, LinkInfo(ne.LinkId(next_link_id[]),
                                          ne.PinId(start_val),
                                          ne.PinId(end_val)))
                    next_link_id[] += 1
                end
            end
        end
        ne.EndCreate()

        # Handle links the user deletes (select a link and press Delete).
        if ne.BeginDelete()
            while ne.QueryDeletedLink(deleted_link)
                if ne.AcceptDeletedItem()
                    dv = ne.value(deleted_link)
                    filter!(l -> ne.value(l.id) != dv, links)
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
