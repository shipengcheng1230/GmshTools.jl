using Test
using GmshReader

SAMPLEDIR = joinpath(@__DIR__, "samples")

@testset "Read Gmsh API Sample Meshes" begin
    for samplefile in filter!(x -> endswith(x, ".msh"), readdir(SAMPLEDIR))
        try
            rawdata = read_gmsh_ascii(abspath(joinpath(SAMPLEDIR, samplefile)))
            @test true
        catch
            error("Error when reading: $(samplefile)")
        end
    end
end
