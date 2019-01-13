using Base.Threads
using FEMBase

const GmshCode2FEMBaseType = Dict(
    1 => Seg2,
    2 => Tri3,
    3 => Quad4,
    4 => Tet4,
    5 => Hex8,
    6 => Wedge6,
    7 => Pyr5,
    8 => Seg3,
    9 => Tri6,
    10 => Quad9,
    11 => Tet10,
    12 => Hex27,
    15 => Poi1,
    16 => Quad8,
    17 => Hex20,
    18 => Wedge15,
    )

function gmsh_read_mesh(fname::AbstractString)
    meshraw = read_gmsh_ascii(fname)
    nelements = length(meshraw["Elements"]["tags"])
    elements = Vector{Element}(undef, nelements)
    @inbounds @threads for i = 1: nelements
        eltype = GmshCode2FEMBaseType[meshraw["Elements"]["typeEles"][i]]
        elverts = meshraw["Elements"]["numVerts"][i]
        elements[i] = Element(eltype, elverts)
        update!(elements[i], "tagEntity", meshraw["Elements"]["tagEntities"][i])
    end
    nodes = meshraw["Nodes"]
    nnodes = length(nodes["tags"])
    geometry = [nodes["tags"][i] => [nodes["xs"][i], nodes["ys"][i], nodes["zs"][i]] for i in 1: nnodes] |> Dict
    update!(elements, "geometry", geometry)
    return elements, meshraw
end
