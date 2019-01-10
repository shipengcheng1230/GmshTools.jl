using GmshReader
using Makie

# ##2D Triangle-3 Mesh

sampledir = joinpath(dirname(pathof(GmshReader)), "../test/samples") |> abspath
fname = joinpath(sampledir, "t1.msh")
meshraw = read_gmsh_ascii(fname)
coordinates = cat(meshraw["Nodes"]["xs"], meshraw["Nodes"]["ys"]; dims=2)
triangle_index = meshraw["Elements"]["typeEles"] .== 2
connectivity = reduce(hcat, meshraw["Elements"]["numVerts"][triangle_index])'
scene = mesh(coordinates, connectivity; shading=false, color=:white);
wireframe!(scene[end][1], color=(:deepskyblue, 0.1), linewidth=3)

# ##3D Tetrahedron-4 Mesh

fname = joinpath(sampledir, "t3.msh")
meshraw = read_gmsh_ascii(fname)
coordinates = cat(meshraw["Nodes"]["xs"], meshraw["Nodes"]["ys"], meshraw["Nodes"]["zs"]; dims=2)
tetrahedron_index = meshraw["Elements"]["typeEles"] .== 4
connectivity = reduce(hcat, meshraw["Elements"]["numVerts"][tetrahedron_index])'
scene = mesh(coordinates, connectivity; shading=false, color=:white);
wireframe!(scene[end][1], color=(:deepskyblue, 0.1), linewidth=3, transparency=true)
