module GmshTools

using Libdl

const gmshmodule = joinpath(@__DIR__, "..", "deps", "usr", "lib", "gmsh.jl")
include(joinpath(gmshmodule))

function __init__()
    using gmsh
end

export @gmsh_open

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
