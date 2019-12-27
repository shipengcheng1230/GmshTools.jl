module GmshTools

using MLStyle

const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")

function __init__()
    try
        include(depsjl_path)
        gmshmodule = joinpath(dirname(libgmsh), "gmsh.jl")
        include(gmshmodule)
        Base.invokelatest(check_deps) # world age problem
    catch ex
        if isa(ex, ErrorException)
            @error "libgmsh not installed properly. Please check *.travis* for additional dependencies and rebuild this package."
        else
            rethrow(ex)
        end
    end
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
