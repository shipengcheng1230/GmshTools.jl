using GmshReader
using Test

demos = ["t1.jl", "t2.jl", "t3.jl", "t4.jl", "t16.jl"]

function test_api(x)
    include(joinpath(@__DIR__, x))
    mshname = splitext(x)[1] * ".msh"
    mv(joinpath(@__DIR__, mshname), joinpath(@__DIR__, "samples", mshname); force=true)
end

try
    foreach(test_api, demos)
    @test true
catch
    @test false
end

@test @gmsh_open joinpath(@__DIR__, "samples", "t1.msh") begin
    gmsh.model.getDimension()
end == 2
