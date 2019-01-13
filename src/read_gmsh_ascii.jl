using FileIO

function verify_close_tag(s1::S, s2::S; ctag="End"::S) where {S <: AbstractString}
    s1[1] * ctag * s1[2:end] == s2 || error("Unmatched close tag $s1, expected $s2")
end

verify_close_tag(f::IOStream, header::AbstractString) = verify_close_tag(header, readline(f))

function read_msh!(dict::AbstractDict, f::IOStream, ::Val{:MeshFormat})
    version = map(x->parse(Int, x), readline(f) |> split)
    @assert version[1] ≥ 4 "Only Support Version 4, got $(version[1])."
    @assert version[2] ≠ 1 "Only Support ASCII, got binary mode."
    verify_close_tag(f, "\$MeshFormat")
    dict["MeshFormat"] = Dict("Format"=>version[1], "Mode"=>version[2], "DataSize"=>version[3])
end

function read_msh!(dict::AbstractDict, f::IOStream, ::Val{:PhysicalNames})
    numPhysicalNames = parse(Int, readline(f))
    dimensions, tags = [Vector{Int}(undef, numPhysicalNames) for _ in 1: 2]
    names = Vector{String}(undef, numPhysicalNames)
    for i = 1: numPhysicalNames
        line = split(readline(f))
        dimensions[i] = parse(Int, line[1])
        tags[i] = parse(Int, line[2])
        names[i] = strip(join(line[3:end], " "), '\"')
    end
    verify_close_tag(f, "\$PhysicalNames")
    dict["PhysicalNames"] = Dict("numPhysicalNames"=>numPhysicalNames, "dimensions"=>dimensions, "tags"=>tags, "names"=>names)
end

function read_msh!(dict::AbstractDict, f::IOStream, ::Val{:Entities})
    numPoints, numCurves, numSurfaces, numVolumes = map(x->parse(Int, x), split(readline(f)))
    dict["Entities"] = Dict()
    dict["Entities"]["Points"] = read_entities_points(f, numPoints)
    dict["Entities"]["Curves"] = read_entities_curves(f, numCurves)
    dict["Entities"]["Surfaces"] = read_entities_surfaces(f, numSurfaces)
    dict["Entities"]["Volumes"] = read_entities_volumes(f, numVolumes)
    verify_close_tag(f, "\$Entities")
end

function read_entities_points(f::IOStream, numPoints::Integer)
    tags, numPhysicals = [Vector{Int}(undef, numPoints) for _ in 1: 2]
    minx, miny, minz, maxx, maxy, maxz = [Vector{Float64}(undef, numPoints) for _ in 1: 6]
    physicalTags = Vector{Vector{Int}}(undef, numPoints)
    for i = 1: numPoints
        items = split(readline(f))
        tags[i], minx[i], miny[i], minz[i], maxx[i], maxy[i], maxz[i], numPhysicals[i], physicalTags[i] =
            parse(Int, items[1]),
            map(x->parse(Float64, x), items[2:7])...,
            parse(Int, items[8]),
            map(x->parse(Int, x), items[9:end])
        @assert length(items) == numPhysicals[i] + 8 "Expected number of line items: $(numPhysicals[i]+8), got $(length(items))"
    end
    return Dict("tags"=>tags, "minx"=>minx, "miny"=>miny, "minz"=>minz, "maxx"=>maxx, "maxy"=>maxy, "maxz"=>maxz, "numPhysicals"=>numPhysicals, "physicalTags"=>physicalTags)
end

function read_entities_curves(f::IOStream, numCurves::Integer)
    tags, numPhysicals, numBoundingPoints = [Vector{Int}(undef, numCurves) for _ in 1: 3]
    minx, miny, minz, maxx, maxy, maxz = [Vector{Float64}(undef, numCurves) for _ in 1: 6]
    physicalTags, tagPoints = [Vector{Vector{Int}}(undef, numCurves) for _ in 1: 2]
    for i = 1: numCurves
        items = split(readline(f))
        tags[i], minx[i], miny[i], minz[i], maxx[i], maxy[i], maxz[i], numPhysicals[i] =
            parse(Int, items[1]),
            map(x->parse(Float64, x), items[2:7])...,
            parse(Int, items[8])
        physicalTags[i], numBoundingPoints[i], tagPoints[i] =
            map(x->parse(Int, x), items[9:8+numPhysicals[i]]),
            parse(Int, items[9+numPhysicals[i]]),
            map(x->parse(Int, x), items[10+numPhysicals[i]:end])
        @assert length(items) == 9 + numPhysicals[i] + numBoundingPoints[i] "Expected number of line items: $(numPhysicals[i]+numBoundingPoints[i]+9), got $(length(items))"
    end
    return Dict("tags"=>tags, "minx"=>minx, "miny"=>miny, "minz"=>minz, "maxx"=>maxx, "maxy"=>maxy, "maxz"=>maxz, "numPhysicals"=>numPhysicals, "physicalTags"=>physicalTags, "numBoundingPoints"=>numBoundingPoints, "tagPoints"=>tagPoints)
end

const read_entities_surfaces = read_entities_curves
const read_entities_volumes = read_entities_curves

function read_msh!(dict::AbstractDict, f::IOStream, ::Val{:Nodes})
    numEntityBlocks, numNodes = map(x->parse(Int, x), split(readline(f)))
    tagEntities, dimEntities, parametrics, tags = [Vector{Int}(undef, numNodes) for _ in 1: 4]
    xs, ys, zs = [Vector{Float64}(undef, numNodes) for _ in 1: 3]
    count = 0
    for i = 1: numEntityBlocks
        tagEntity, dimEntity, parametric, numNodesPerEntity = map(x->parse(Int, x), split(readline(f)))
        for j = 1: numNodesPerEntity
            ind = count + j
            items = split(readline(f))
            tag, x, y, z = parse(Int, items[1]), map(x->parse(Float64, x), items[2:end])...
            tags[ind], xs[ind], ys[ind], zs[ind] = tag, x, y, z
            tagEntities[ind], dimEntities[ind], parametrics[ind] = tagEntity, dimEntity, parametric
        end
        count += numNodesPerEntity
    end
    @assert count == numNodes "Expected number of nodes: $numNodes, got $count"
    verify_close_tag(f, "\$Nodes")
    dict["Nodes"] = Dict("tagEntities"=>tagEntities, "dimEntities"=>dimEntities, "parametrics"=>parametrics, "tags"=>tags, "xs"=>xs, "ys"=>ys, "zs"=>zs)
end

function read_msh!(dict::AbstractDict, f::IOStream, ::Val{:Elements})
    numEntityBlocks, numElements = map(x->parse(Int, x), split(readline(f)))
    tagEntities, dimEntities, typeEles, tags = [Vector{Int}(undef, numElements) for _ in 1: 4]
    numVerts = Vector{Vector{Int}}(undef, numElements)
    count = 0
    for i = 1: numEntityBlocks
        tagEntity, dimEntity, typeEle, numElementsPerEntity = map(x->parse(Int, x), split(readline(f)))
        for j = 1: numElementsPerEntity
            ind = count+j
            items = split(readline(f))
            tagEntities[ind], dimEntities[ind], typeEles[ind] = tagEntity, dimEntity, typeEle
            tags[ind] = parse(Int, items[1])
            numVerts[ind] = map(x->parse(Int, x), items[2:end])
        end
        count += numElementsPerEntity
    end
    @assert count == numElements "Expected number of elements: $numElements, got $count"
    verify_close_tag(f, "\$Elements")
    return dict["Elements"] = Dict("tagEntities"=>tagEntities, "dimEntities"=>dimEntities, "typeEles"=>typeEles, "tags"=>tags, "numVerts"=>numVerts)
end

function read_msh!(dict::AbstractDict, f::IOStream, ::Val{:skip}, tag; warning=true)
    warning && @warn "Skip $(tag[5:end]) section."
    while true
        strip(readline(f)) == tag && break
    end
end

read_msh!(dict::AbstractDict, f::IOStream, ::Val{:Comment}) = read_msh!(dict, f, Val(:skip), "\$EndComment"; warning=false)
read_msh!(dict::AbstractDict, f::IOStream, ::Val{:Periodic}) = read_msh!(dict, f, Val(:skip), "\$EndPeriodic")
read_msh!(dict::AbstractDict, f::IOStream, ::Val{:NodeData}) = read_msh!(dict, f, Val(:skip), "\$EndNodeData")
read_msh!(dict::AbstractDict, f::IOStream, ::Val{:ElementData}) = read_msh!(dict, f, Val(:skip), "\$EndElementData")
read_msh!(dict::AbstractDict, f::IOStream, ::Val{:ElementNodeData}) = read_msh!(dict, f, Val(:skip), "\$EndElementNodeData")
read_msh!(dict::AbstractDict, f::IOStream, ::Val{:InterpolationScheme}) = read_msh!(dict, f, Val(:skip), "\$EndInterpolationScheme")

function read_gmsh_ascii(fname::String)
    isfile(fname) || error("Invalid fname $fname.")
    rawdata = Dict()
    open(fname, "r") do f
        while !eof(f)
            header = readline(f)
            read_msh!(rawdata, f, Val(Symbol(header[2:end])))
        end
    end
    return rawdata
end
