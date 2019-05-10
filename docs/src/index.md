# GmshTools.jl

## Introduction

To read the [Gmsh](http://gmsh.info/) mesh file.

## Install
```julia
(v1.1) pkg> add https://github.com/shipengcheng1230/GmshTools.jl
```

## Limitations

Due to some failure of building tarballs or write `deps.jl`, the `libgmsh` here does not rely on `build_tarballs` by [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl). Instead, it downloads the Gmsh SDK directly and unpack them (see [build.jl](https://github.com/shipengcheng1230/GmshTools.jl/blob/master/deps/build.jl)).

## Version

The current SDK version is 4.3.0. The *.msh* format is 4.1 (not back-compatible).

## Usage

```julia
using GmshTools

gmsh.initialize()
gmsh.finalize()
```

The `@gmsh_open` provide a *do-block* like use:

```julia
@gmsh_open msh_file begin
    gmsh.model.getDimension()
end
```

To retrieve various mesh information, please refer the [Gmsh Julia API](https://gitlab.onelab.info/gmsh/gmsh/blob/master/api/gmsh.jl).
