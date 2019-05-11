module GmshTools

using Libdl

const gmshmodule = joinpath(@__DIR__, "..", "deps", "usr", "lib", "gmsh.jl")

@static !Sys.islinux() && begin
    include(gmshmodule)
    export gmsh
end

function __init__()
    # workround for v4.3.0 on Linux
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

include("transfinite_mesh.jl")

end
