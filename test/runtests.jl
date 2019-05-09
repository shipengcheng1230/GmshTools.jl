using GmshReader

TESTDIR = @__DIR__

for file in filter(x->startswith(x, "test_"), readdir(TESTDIR))
    include(joinpath(TESTDIR, file))
end


include(joinpath(TESTDIR, "test_gmsh_api.jl"))
