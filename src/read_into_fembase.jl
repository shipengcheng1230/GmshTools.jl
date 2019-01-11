using Base.Threads

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
