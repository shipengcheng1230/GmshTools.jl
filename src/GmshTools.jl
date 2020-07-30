module GmshTools

using Requires

const depsfile = joinpath(@__DIR__, "..", "deps", "deps.jl")
# if isfile(depsfile)
#     include(depsfile)
# else
#     error("GmshTools is not properly installed. Please run Pkg.build(\"GmshTools\") ",
#           "and restart Julia.")
# end

function __init__()
    # check_deps()
    @require Gmsh_SDK_jll="4abbd9bc-5e42-58f8-a031-9aef3230cdd8" begin
        isfile(depsfile) || include(joinpath(dirname(@__DIR__), "deps", "build.jl"))
        include(depsfile)
    end
end

export
    gmsh,
    match_tuple,
    @addField,
    @gmsh_do,
    @gmsh_open

include("macros.jl")

end
