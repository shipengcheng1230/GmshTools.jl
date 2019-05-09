module GmshReader

using Libdl

const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")

if !isfile(depsjl_path)
    error("Gmsh SDK not installed properly, run Pkg.build(\"GmshReader\"), restart Julia and try again")
end

include(depsjl_path)

include("read_gmsh_ascii.jl")

end
