module GmshTools

using Libdl
using MLStyle

const gmshmodule = joinpath(@__DIR__, "..", "deps", "usr", "lib", "gmsh.jl")

@static if !Sys.islinux()
    include(gmshmodule)
    export gmsh
end

function __init__()
    # workround for Gmsh SDK v4.3.0 on Linux otherwise segment fault
    @static Sys.islinux() && Base.include(Main, gmshmodule)
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

include("macros.jl")

end
