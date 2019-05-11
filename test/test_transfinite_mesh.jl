using Test

@testset "equidistant_rectangle" begin
    cx, cy, cz, dx, dy, nx, ny = -1.0, -1.0, 0.0, 2.0, 2.0, 10, 7
    fname = tempname() * ".msh"
    transfinite_rectangle(cx, cy, cz, dx, dy, nx, ny; fname=fname)
    els = @gmsh_open fname begin
        gmsh.model.mesh.getElements(2)
    end
    @test els[1][1] == 3
    @test length(els[2][1]) == nx * ny
    rm(fname)
end
