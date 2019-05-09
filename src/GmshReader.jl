module GmshReader

using Libdl

const gmshmodule = joinpath(@__DIR__, "..", "deps", "usr", "lib", "gmsh.jl")
include(gmshmodule)

export gmsh

include("read_gmsh_ascii.jl")

end
