var documenterSearchIndex = {"docs":
[{"location":"element_types/#Supported-Element-Type","page":"Element Types","title":"Supported Element Type","text":"","category":"section"},{"location":"element_types/","page":"Element Types","title":"Element Types","text":"info: [Complete Element Type Codes](http://gmsh.info/doc/texinfo/gmsh.html#File-formats)\nCode Type Description\n1 2-node line \n2 3-node triangle \n3 4-node quadrangle \n4 4-node tetrahedron \n5 8-node hexahedron \n6 6-node prism \n7 5-node pyramid \n8 3-node second order line (2 nodes associated with the vertices and 1 with the edge).\n9 6-node second order triangle (3 nodes associated with the vertices and 3 with the edges).\n10 9-node second order quadrangle (4 nodes associated with the vertices, 4 with the edges and 1 with the face).\n11 10-node second order tetrahedron (4 nodes associated with the vertices and 6 with the edges).\n12 27-node second order hexahedron (8 nodes associated with the vertices, 12 with the edges, 6 with the faces and 1 with the volume).\n13 18-node second order prism (6 nodes associated with the vertices, 9 with the edges and 3 with the quadrangular faces).\n14 14-node second order pyramid (5 nodes associated with the vertices, 8 with the edges and 1 with the quadrangular face).\n15 1-node point \n16 8-node second order quadrangle (4 nodes associated with the vertices and 4 with the edges).\n17 20-node second order hexahedron (8 nodes associated with the vertices and 12 with the edges).\n18 15-node second order prism (6 nodes associated with the vertices and 9 with the edges).\n19 13-node second order pyramid (5 nodes associated with the vertices and 8 with the edges).\n20 9-node third order incomplete triangle (3 nodes associated with the vertices, 6 with the edges)\n21 10-node third order triangle (3 nodes associated with the vertices, 6 with the edges, 1 with the face)\n22 12-node fourth order incomplete triangle (3 nodes associated with the vertices, 9 with the edges)\n23 15-node fourth order triangle (3 nodes associated with the vertices, 9 with the edges, 3 with the face)\n24 15-node fifth order incomplete triangle (3 nodes associated with the vertices, 12 with the edges)\n25 21-node fifth order complete triangle (3 nodes associated with the vertices, 12 with the edges, 6 with the face)\n26 4-node third order edge (2 nodes associated with the vertices, 2 internal to the edge)\n27 5-node fourth order edge (2 nodes associated with the vertices, 3 internal to the edge)\n28 6-node fifth order edge (2 nodes associated with the vertices, 4 internal to the edge)\n29 20-node third order tetrahedron (4 nodes associated with the vertices, 12 with the edges, 4 with the faces)\n30 35-node fourth order tetrahedron (4 nodes associated with the vertices, 18 with the edges, 12 with the faces, 1 in the volume)\n31 56-node fifth order tetrahedron (4 nodes associated with the vertices, 24 with the edges, 24 with the faces, 4 in the volume)\n92 64-node third order hexahedron (8 nodes associated with the vertices, 24 with the edges, 24 with the faces, 8 in the volume)\n93 125-node fourth order hexahedron (8 nodes associated with the vertices, 36 with the edges, 54 with the faces, 27 in the volume)","category":"page"},{"location":"#GmshTools.jl","page":"Index","title":"GmshTools.jl","text":"","category":"section"},{"location":"#Install","page":"Index","title":"Install","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"(v1.6) pkg> add GmshTools","category":"page"},{"location":"#Use-Existed-Library","page":"Index","title":"Use Existed Library","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"using Pkg\n\njulia> ENV[\"GMSHROOT\"] = \"/opt/gmsh\"; # here is your root directory of Gmsh SDK\n\njulia> Pkg.build(\"GmshTools\")","category":"page"},{"location":"#SDK-Version","page":"Index","title":"SDK Version","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"Please check gmsh_jll for the SDK version automatically downloaded.","category":"page"},{"location":"#Basic-Usage","page":"Index","title":"Basic Usage","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"using GmshTools\n\ngmsh.initialize()\ngmsh.finalize()\n\n@gmsh_do begin\n    # automatically handle initialize and finalize\nend\n\n@gmsh_open msh_file begin\n    gmsh.model.getDimension()\n    # any gmsh API here ...\nend\n\n@gmsh_do begin\n\n    @addPoint begin\n        x1, y1, z1, mesh_size_1, point_tag_1\n        x2, y2, z2, mesh_size_2, point_tag_2\n        ...\n    end\n\n    @addLine begin\n        point_tag_1, point_tag_2, line_tag_1\n        point_tag_2, point_tag_3, line_tag_2\n        ...\n    end\n\n    @setTransfiniteCurve begin\n        line_tag_1, num_points_1, Algorithm_1, coefficient_1\n        line_tag_2, num_points_2, Algorithm_2, coefficient_2\n        ...\n    end\n\n    @addField FieldTag FieldName begin\n        name_1, value_1\n        name_2, value_2\n        ...\n        # all added to `FieldTag` field\n    end\n\n    @addOption begin\n        name_1, value_1\n        name_2, value_2\n        ...\n    end\n\n    # more gmsh APIs ...\nend","category":"page"},{"location":"","page":"Index","title":"Index","text":"You may see test files for more concrete examples. More convenient macros will come in the future.","category":"page"},{"location":"","page":"Index","title":"Index","text":"To retrieve various mesh information, please refer the Gmsh Julia API.","category":"page"}]
}
