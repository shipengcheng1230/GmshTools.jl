# Workaround for JuliaLang/julia/pull/28625
if Base.HOME_PROJECT[] !== nothing
    Base.HOME_PROJECT[] = abspath(Base.HOME_PROJECT[])
end

using Documenter
using DocumenterMarkdown
using GmshReader

# include("generate.jl")

makedocs(
    doctest=false,
    modules = [GmshReader],
    format = Markdown(),
)

deploydocs(
  repo = "github.com/shipengcheng1230/GmshReader.jl.git",
  deps = Deps.pip("pymdown-extensions", "pygments", "mkdocs", "python-markdown-math", "mkdocs-material"),
  target = "site",
  make = () -> run(`mkdocs build`),
)
