import ImGuiNodeEditor
using Documenter
import Changelog

# Revise to catch any docstring changes
if isdefined(Main, :Revise)
    Revise.revise()
end

# Note that the changelog file is named `_changelog.md` so we can use
# `changelog.md` as the generated name, which makes for a prettier URL.
Changelog.generate(
    Changelog.Documenter(),
    joinpath(@__DIR__, "src/_changelog.md"),
    joinpath(@__DIR__, "src/changelog.md"),
    repo="JuliaImGui/ImGuiNodeEditor.jl"
)

makedocs(; repo = Remotes.GitHub("JuliaImGui", "ImGuiNodeEditor.jl"),
         sitename = "ImGuiNodeEditor.jl",
         format = Documenter.HTML(; prettyurls=get(ENV, "CI", "false") == "true",
                                  size_threshold=2_000_000,
                                  size_threshold_warn=2_000_000),
         pagesonly = true,
         # warnonly = [:missing_docs],
         pages = [
             "index.md",
             "api.md",
             "changelog.md"
         ],
         modules = [ImGuiNodeEditor],
         )

deploydocs(; repo="github.com/JuliaImGui/ImGuiNodeEditor.jl.git")
