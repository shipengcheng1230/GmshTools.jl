# GmshTools.jl


## Install
```julia
(v1.1) pkg> add GmshTools
```

## Limitations

Due to some failure of building tarballs or writing `deps.jl`, the `libgmsh` here does not rely on `build_tarballs` by [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl). Instead, it downloads the Gmsh SDK directly and unpack them (see [build.jl](https://github.com/shipengcheng1230/GmshTools.jl/blob/master/deps/build.jl)). The module `gmsh.jl` is then loaded into `Main` to avoid segment fault on Linux (no problem on MacOS or Windows).

## Version

The current SDK version is 4.3.0. The *.msh* format is 4.1 (not back-compatible).

## Usage

```julia
using GmshTools

gmsh.initialize()
gmsh.finalize()

@gmsh begin
    ... # automatically handle initialize and finalize
end

@gmsh_open msh_file begin
    gmsh.model.getDimension()
end
```

To retrieve various mesh information, please refer the [Gmsh Julia API](https://gitlab.onelab.info/gmsh/gmsh/blob/master/api/gmsh.jl).
