module GmshReader

using Libdl

export gmsh

const deps_path = joinpath(@__DIR__, "..", "deps")
const depsjl = joinpath(deps_path, "deps.jl")

if !isfile(depsjl)
    error("Gmsh SDK not installed properly, run Pkg.build(\"GmshReader\"), restart Julia and try again")
end

include(depsjl)

function __init__()
    check_deps()
end

include(joinpath(deps_path, "usr/lib/gmsh.jl"))
include("read_gmsh_ascii.jl")

end
