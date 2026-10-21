module ImGuiNodeEditor

include("../lib/x86_64-linux-gnu.jl")

using DocStringExtensions: DocStringExtensions
@static if pkgversion(DocStringExtensions) >= v"0.10"
    const TYPEDSIGNATURES = DocStringExtensions.TypedMethodSignatures(defaults=true)
else
    using DocStringExtensions: TYPEDSIGNATURES
end

using CImGui: CImGui as ig, ImVec2, ImVec4
include("wrapper.jl")

# Renamed in Dear ImGui 1.93 (CImGui v10)
@static if pkgversion(ig) >= v"10"
    const set_pixel_density = ig.SetPixelDensity
    const get_pixel_density = ig.GetPixelDensity
else
    const set_pixel_density = ig.SetFontRasterizerDensity
    const get_pixel_density = ig.GetFontRasterizerDensity
end

"""
    current_scale() -> Float32

Factor by which the canvas magnifies drawn content on screen: `> 1` when zoomed
in, `< 1` when zoomed out. This is the reciprocal of [`GetCurrentZoom`](@ref),
which returns the canvas InvScale (and so reads backwards). Returns `1` when no
editor is active, or when the zoom is non-positive (which a corrupt settings
file or a bad `CustomZoomLevels` can produce).
"""
function current_scale()
    if GetCurrentEditor() == C_NULL
        return 1f0
    end

    zoom = GetCurrentZoom()
    return zoom > 0 ? 1f0 / zoom : 1f0
end

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
        saved_density = get_pixel_density()

        ig.PushFont(C_NULL, base_size * $(esc(scale)) / magnification)
        set_pixel_density(exp2(ceil(log2(magnification))))
        try
            $(esc(body))
        finally
            set_pixel_density(saved_density)
            ig.PopFont()
        end
    end
end

end # module ImGuiNodeEditor
