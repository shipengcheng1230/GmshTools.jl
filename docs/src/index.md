# GmshReader.jl

## Introduction

To read the [Gmsh](http://gmsh.info/) mesh file.

## Install
```julia
(v1.0) pkg> add https://github.com/shipengcheng1230/GmshReader.jl
```

## Limitations

- Current only support **version 4** of **ASCII** mode.
- The following tags will be omitted:
    - `<$Periodic>`
    - `<$NodeData>`
    - `<$ElementData>`
    - `<$ElementNodeData>`
    - `<$InterpolationScheme>`


- Element type of `Tri7` of [FEMBase](https://github.com/JuliaFEM/FEMBase.jl) is not supported since [Gmsh](http://gmsh.info/) does not have an equivalence type.

## Utilities

Brief Summary:

- [`read_gmsh_ascii`](@ref) return a `Dict` of all supported fields that are self-explained.

- [`gmsh_read_mesh`](@ref) return a `Vector{Element}` along with the result returned by [`read_gmsh_ascii`](@ref). The later part contains useful information for further manipulation.


For [FEMBase](https://github.com/JuliaFEM/FEMBase.jl) elements:
- **"geometry"** field is updated using `numVerts`

- **"tagEntity"** field of each element is stored using `tagEntities`. This field indicates which one of `Entities`, by comparing with its `tags`, a mesh bounds to (A 0D mesh, hence 1-node point, bounds to one of the `Points`, a 1D mesh `Curves`, a 2D mesh `Surfaces` and a 3D mesh `Volumes`).

- The `physicalTags` of those `Entities` denotes which physical group recorded by `tags` inside `PhysicalNames`, of the same `dimensions`, it bounds.
