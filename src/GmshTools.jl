module GmshTools

using MLStyle

const depsfile = joinpath(@__DIR__, "..", "deps", "deps.jl")
if isfile(depsfile)
    include(depsfile)
else
    error("GmshTools is not properly installed. Please run Pkg.build(\"GmshTools\") ",
          "and restart Julia.")
end

function __init__()
    check_deps()
end

export gmsh, @gmsh_do, @gmsh_open

macro gmsh_do(f)
    quote
        try
            gmsh.initialize()
            $(esc(f))
        finally
            gmsh.finalize()
        end
    end
end

macro gmsh_open(name, f)
    quote
        try
            gmsh.initialize()
            gmsh.open($(esc(name)))
            $(esc(f))
        finally
            gmsh.finalize()
        end
    end
end

include("macros.jl")

end
