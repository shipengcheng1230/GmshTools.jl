module GmshTools

using MLStyle

const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    error("libgmsh not installed properly, run Pkg.build(\"GmshTools\"), restart Julia and try again")
end
include(depsjl_path)

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
