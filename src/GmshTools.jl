module GmshTools

using Libdl

const gmshmodule = joinpath(@__DIR__, "..", "deps", "usr", "lib", "gmsh.jl")

function __init__()
    push!(LOAD_PATH, dirname(GmshTools.gmshmodule))
    @eval Main using gmsh
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
