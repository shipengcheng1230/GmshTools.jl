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
    nels = length(meshraw["Elements"]["tags"])
    els = Vector{Element}(undef, nels)
    @inbounds @threads for i = 1: nels
        eltype = GmshCode2FEMBaseType[meshraw["Elements"]["typeEles"][i]]
        elverts = meshraw["Elements"]["numVerts"][i]
        els[i] = Element(eltype, elverts)
    end
    nodes = meshraw["Nodes"]
    nnodes = length(nodes["tags"])
    geometry = [nodes["tags"][i] => [nodes["xs"][i], nodes["ys"][i], nodes["zs"][i]] for i in 1: nnodes] |> Dict
    update!(els, "geometry", geometry)
    return els
end
