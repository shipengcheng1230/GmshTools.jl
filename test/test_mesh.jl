using Test

@testset "transfinite_rectangle" begin
    fname = tempname() * ".msh"
    nx, ny = 10, 7
    coefx, coefy = 1.2, 1.2
    @gmsh_do begin
        @addPoint begin
            -1.0, -1.0, 0.0, 1
            1.0, -1.0, 0.0, 2
            1.0, 1.0, 0.0, 3
            -1.0, 1.0, 0.0, 4
        end
        @addLine begin
            1, 2
            2, 3
            4, 3
            1, 4
        end
        gmsh.model.geo.addCurveLoop([1, 2, -3, -4], 1)
        gmsh.model.geo.addPlaneSurface([1], 1)
        gmsh.model.geo.mesh.setTransfiniteSurface(1, "Left", [1, 2, 3, 4])
        @setTransfiniteCurve begin
            1, nx+1, "Progression", coefx
            3, nx+1, "Progression", coefx
            2, ny+1, "Progression", coefy
            4, ny+1, "Progression", coefy
        end
        gmsh.model.geo.mesh.setRecombine(2, 1)
        gmsh.model.geo.synchronize()
        gmsh.model.mesh.generate(2)
        gmsh.write(fname)
    end

    els = @gmsh_open fname begin
        gmsh.model.mesh.getElements(2)
    end
    @test els[1][1] == 3
    @test length(els[2][1]) == nx * ny
    rm(fname)
end
