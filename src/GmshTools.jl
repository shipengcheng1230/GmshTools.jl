module GmshTools

using MLStyle

const gmshmodule = joinpath(@__DIR__, "..", "deps", "usr", "lib", "gmsh.jl")

@static Sys.islinux() || include(gmshmodule)

function __init__()
    # Tried lots of approaches, this is one of the workrounds for Gmsh SDK v4.3.0 on Linux
    # otherwise segment fault if you `gmsh.initialize()`
    @static Sys.islinux() && Base.include(@__MODULE__, gmshmodule)
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
