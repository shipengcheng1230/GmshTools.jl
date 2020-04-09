# Workaround for JuliaLang/julia/pull/28625
if Base.HOME_PROJECT[] !== nothing
    Base.HOME_PROJECT[] = abspath(Base.HOME_PROJECT[])
end

using Documenter
# using DocumenterMarkdown
using GmshTools

# include("generate.jl")

makedocs(
    doctest=false,
    modules = [GmshTools],
    sitename = "GmshTools",
    # format = Markdown(),
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    pages = [
        "Index" => "index.md",
        "Element Types" => "element_types.md",
    ],
)

deploydocs(
  repo = "github.com/shipengcheng1230/GmshTools.jl.git",
  # deps = Deps.pip("pymdown-extensions", "pygments", "mkdocs", "python-markdown-math", "mkdocs-material"),
  target = "build",
  # make = () -> run(`mkdocs build`),
)
