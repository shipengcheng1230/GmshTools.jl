module GmshTools

using Libdl

const gmshmodule = joinpath(@__DIR__, "..", "deps", "usr", "lib", "gmsh.jl")
include(joinpath(gmshmodule))

export @gmsh_open
@static Sys.islinux() || export gmsh

macro gmsh_open(name, f)
    esc(quote
        try
            gmsh.initialize()
            gmsh.open($(name))
            $(f)
        finally
            gmsh.finalize()
        end
    end)
end

end
