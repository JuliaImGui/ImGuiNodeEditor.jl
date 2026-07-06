module ImGuiNodeEditor

include("../lib/x86_64-linux-gnu.jl")

using DocStringExtensions: TYPEDSIGNATURES
using CImGui: CImGui as ig, ImVec2, ImVec4
include("wrapper.jl")

"""
    current_scale() -> Float32

Factor by which the canvas magnifies drawn content on screen: `> 1` when zoomed
in, `< 1` when zoomed out. This is the reciprocal of [`GetCurrentZoom`](@ref),
which returns the canvas InvScale (and so reads backwards). Returns `1` when no
editor is active.
"""
current_scale() = (zoom = GetCurrentZoom(); zoom > 0 ? 1f0 / zoom : 1f0)

"""
    @with_font_scale scale body

Run `body` with a font pushed so text drawn inside the node canvas renders at
`scale`× the base font size **as measured on screen**, regardless of zoom. The
canvas magnifies the draw list by [`current_scale`](@ref), so the local font is
sized to `scale / current_scale()` and the glyphs are baked at their on-screen
size (rasterizer density = the magnification, snapped to a power of two) — this
keeps them crisp rather than minifying a too-large atlas (which aliases). Font
and rasterizer density are restored afterwards; `body`'s value is forwarded.

For example, a node title that stays readable (capped at 1× on screen) when
zooming out but grows freely when zooming in:
```julia
@with_font_scale max(1f0, current_scale()) draw_title()
```
"""
macro with_font_scale(scale, body)
    quote
        magnification = current_scale()
        base_size = unsafe_load(ig.GetStyle()).FontSizeBase
        saved_density = ig.GetFontRasterizerDensity()

        ig.PushFont(C_NULL, base_size * $(esc(scale)) / magnification)
        ig.SetFontRasterizerDensity(exp2(ceil(log2(magnification))))
        try
            $(esc(body))
        finally
            ig.SetFontRasterizerDensity(saved_density)
            ig.PopFont()
        end
    end
end

end # module ImGuiNodeEditor
