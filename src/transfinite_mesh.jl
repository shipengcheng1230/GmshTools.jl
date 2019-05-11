export transfinite_rectangle

function transfinite_rectangle(
    cx::Float64, cy::Float64, cz::Float64, dx::Float64, dy::Float64, nx::Integer, ny::Integer;
    fname="temp.msh", coefx::Float64=1.0, coefy::Float64=1.0) where T<:Real
    @gmsh_do begin
        factory = gmsh.model.geo

        p1 = factory.addPoint(cx, cy, cz)
        p2 = factory.addPoint(cx+dx, cy, cz)
        p3 = factory.addPoint(cx+dx, cy+dy, cz)
        p4 = factory.addPoint(cx, cy+dy, cz)

        l1 = factory.addLine(p1, p2)
        l2 = factory.addLine(p2, p3)
        l3 = factory.addLine(p4, p3)
        l4 = factory.addLine(p1, p4)

        cl1 = factory.addCurveLoop([p1, p2, -p3, -p4])
        s1 = factory.addPlaneSurface([cl1])

        factory.mesh.setTransfiniteSurface(s1, "Left", [p1, p2, p3, p4])
        factory.mesh.setTransfiniteCurve(l1, nx+1, "Progression", coefx)
        factory.mesh.setTransfiniteCurve(l3, nx+1, "Progression", coefx)
        factory.mesh.setTransfiniteCurve(l2, ny+1, "Progression", coefy)
        factory.mesh.setTransfiniteCurve(l4, ny+1, "Progression", coefy)

        factory.mesh.setRecombine(2, s1)
        gmsh.model.geo.synchronize()
        gmsh.model.mesh.generate(2)
        gmsh.write(fname)
    end
end
