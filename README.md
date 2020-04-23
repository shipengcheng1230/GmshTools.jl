# GmshTools.jl

[![Build Status](https://travis-ci.com/shipengcheng1230/GmshTools.jl.svg?branch=master)](https://travis-ci.com/shipengcheng1230/GmshTools.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/sk0gh2mhfurj2otv/branch/master?svg=true)](https://ci.appveyor.com/project/shipengcheng1230/gmshtools-jl/branch/master)
[![codecov](https://codecov.io/gh/shipengcheng1230/GmshTools.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/shipengcheng1230/GmshTools.jl)
[![Coverage Status](https://coveralls.io/repos/github/shipengcheng1230/GmshTools.jl/badge.svg?branch=master)](https://coveralls.io/github/shipengcheng1230/GmshTools.jl?branch=master)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://shipengcheng1230.github.io/GmshTools.jl/stable/)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://shipengcheng1230.github.io/GmshTools.jl/dev/)

To use [Gmsh](http://gmsh.info/) mesh program.

# Notice

- Users could set the environment variable `GMSH_LIB_PATH` to your source-compiled Gmsh library
  directory and rebuild this package. For windows user, you need to create a link from `gmsh-*.*.dll` to `libgmsh.dll` since something changed regarding `find_library` after Julia *v1.4*.

- If your Julia is compiled with [Intel MKL](https://github.com/JuliaComputing/MKL.jl), then it must be compiled with 32 integer interface (otherwise Julia will crash due to BLAS interface incompatibility), i.e. linking to **lp64** instead of **ipl64**. To do so, in `Make.inc`, change to
```makefile
export MKL_INTERFACE_LAYER := LP64
MKLLIB := $(MKLROOT)/lib/intel64
```

- Since *v0.4.0*, you will need to manually install [Gmsh_SDK_jll.jl](https://github.com/shipengcheng1230/Gmsh_SDK_jll.jl), which, due to some building issues, cannot fit into [JuliaBinaryWrappers](https://github.com/JuliaBinaryWrappers) for now. The building procedure is hosted at [GmshBuilder.jl](https://github.com/shipengcheng1230/GmshBuilder.jl).
