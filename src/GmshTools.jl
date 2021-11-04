module GmshTools

using Libdl

deps_jl = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(deps_jl)
  s = """
  Package GmshTools not installed properly.
  Run Pkg.build(\"GmshTools\"), restart Julia and try again.
  """
  error(s)
end

include(deps_jl)

if GMSH_FOUND
  include(gmsh_jl)
  # Hack taken from MPI.jl
  function __init__()
    @static if Sys.isunix()
      Libdl.dlopen(gmsh.lib, Libdl.RTLD_LAZY | Libdl.RTLD_GLOBAL)
    end
  end
else
    s = """
    Gmsh not found in system paths.
    Install Gmsh or export path to Gmsh and rebuild the project.
    Run Pkg.build(\"GmshTools\"), restart Julia and try again.
    """
    @warn s
end

export
    gmsh,
    match_tuple,
    @addField,
    @gmsh_do,
    @gmsh_open

include("macros.jl")

end
