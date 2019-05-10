module GmshTools

__precompile__(false)

using Libdl

const gmshmodule = joinpath(@__DIR__, "..", "deps", "usr", "lib", "gmsh.jl")
Base.include(Main, gmshmodule)

function __init__()
end

export @gmsh_do, @gmsh_open

macro gmsh_do(f)
    esc(quote
        try
            gmsh.initialize()
            $(f)
        finally
            gmsh.finalize()
        end
    end)
end

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
