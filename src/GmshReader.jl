module GmshReader

include("read_gmsh_ascii.jl")
include("read_into_fembase.jl")

export gmsh_read_mesh, read_gmsh_ascii

end
