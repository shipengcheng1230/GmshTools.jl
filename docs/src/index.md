# GmshTools.jl


## Install
```julia
(v1.1) pkg> add GmshTools
```


## Use Existed Library

You may add `ENV["GMSH_LIB_PATH"] = /your/gmsh/lib/path/string` and then run `Pkg.build("GmshTools")`.


## Limitations

Due to some failure of building tarballs and writing `deps.jl`, the `libgmsh` here does not rely on `build_tarballs` by [BinaryBuilder.jl](https://github.com/JuliaPackaging/BinaryBuilder.jl). Instead, it downloads the Gmsh SDK directly and unpack them (see [build.jl](https://github.com/shipengcheng1230/GmshTools.jl/blob/master/deps/build.jl)). The module `gmsh.jl` is loaded in `__init__()` to avoid segment fault on Linux (no problem on MacOS or Windows).

## Version

The current SDK version is 4.4.0. The *.msh* format is 4.1 (not back-compatible).

## Basic Usage

```julia
using GmshTools

gmsh.initialize()
gmsh.finalize()

@gmsh_do begin
    # automatically handle initialize and finalize
end

@gmsh_open msh_file begin
    gmsh.model.getDimension()
    # any gmsh API here ...
end

@gmsh_do begin

    @addPoint begin
        x1, y1, z1, mesh_size_1, point_tag_1
        x2, y2, z2, mesh_size_2, point_tag_2
        ...
    end

    @addLine begin
        point_tag_1, point_tag_2, line_tag_1
        point_tag_2, point_tag_3, line_tag_2
        ...
    end

    @setTransfiniteCurve begin
        line_tag_1, num_points_1, Algorithm_1, coefficient_1
        line_tag_2, num_points_2, Algorithm_2, coefficient_2
        ...
    end

    @addField FieldTag FieldName begin
        name_1, value_1
        name_2, value_2
        ...
        # all added to `FieldTag` field
    end

    @addOption begin
        name_1, value_1
        name_2, value_2
        ...
    end

    # more gmsh APIs ...
end
```

You may see [test files](https://github.com/shipengcheng1230/GmshTools.jl/blob/master/test/test_mesh.jl) for more concrete examples. More convenient macros will come in the future.

To retrieve various mesh information, please refer the [Gmsh Julia API](https://gitlab.onelab.info/gmsh/gmsh/blob/master/api/gmsh.jl).
