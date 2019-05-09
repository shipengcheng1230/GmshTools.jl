module GmshReader

using Libdl

const gmshmodule = joinpath(@__DIR__, "..", "deps", "usr", "lib")

function __init__()
    push!(LOAD_PATH, gmshmodule)
end

include("read_gmsh_ascii.jl")

end
