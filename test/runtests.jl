using GmshTools
using Test

try
    gmsh.initialize()
    @test true
catch
    @test false
finally
    gmsh.finalize()
end

include("test_transfinite_mesh.jl")
