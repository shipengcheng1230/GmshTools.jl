module GmshReader

using Libdl

const gmshmodule = joinpath(@__DIR__, "..", "deps", "usr", "lib")
include(joinpath(gmshmodule, "gmsh.jl"))

export gmsh, @gmsh_open

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
