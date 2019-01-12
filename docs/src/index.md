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


- Element types of `Tri7` of [FEMBase](https://github.com/JuliaFEM/FEMBase.jl) is not supported since [Gmsh](http://gmsh.info/) does not have an equivalence type.
