using Documenter, GmshTools

makedocs(
    doctest=false,
    modules = [GmshTools],
    sitename = "GmshTools",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    pages = [
        "Index" => "index.md",
        "Element Types" => "element_types.md",
    ],
)

deploydocs(
    repo = "github.com/shipengcheng1230/GmshTools.jl.git",
    target = "build",
)
