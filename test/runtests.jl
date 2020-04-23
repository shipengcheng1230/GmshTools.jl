using GmshTools
using Test
using Pkg

# temporary solution to bypass General registry
Pkg.add(PackageSpec(url="https://github.com/shipengcheng1230/Gmsh_SDK_jll.jl"))
using Gmsh_SDK_jll

try
    gmsh.initialize()
    @test true
catch
    @test false
finally
    gmsh.finalize()
end

include("test_mesh.jl")
