using GmshReader
import gmsh

const DEMODIR = joinpath(@__DIR__, "..", "deps", "usr", "share", "doc", "gmsh", "demos", "api") |> abspath
demos = ["t1.jl", "t2.jl", "t3.jl", "t4.jl", "t16.jl"]

function run_api_demo(x)
    include(joinpath(DEMODIR, x))
    mshname = splitext(basename(x))[1] * ".msh"
    mv(joinpath(@__DIR__, mshname), joinpath(@__DIR__, "samples", mshname), force=true)
end

foreach(run_api_demo, demos)
