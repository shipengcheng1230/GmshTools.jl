module GmshReader

using Libdl

const deps_path = joinpath(@__DIR__, "..", "deps")

if !isfile(depsjl_path)
    error("Gmsh SDK not installed properly, run Pkg.build(\"GmshReader\"), restart Julia and try again")
end

include(joinpath(deps_path, "deps.jl"))
include(joinpath(deps_path, "usr/lib/gmsh.jl"))

include("read_gmsh_ascii.jl")

end
