# GmshTools.jl

[![Build Status](https://travis-ci.com/shipengcheng1230/GmshTools.jl.svg?branch=master)](https://travis-ci.com/shipengcheng1230/GmshTools.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/sk0gh2mhfurj2otv/branch/master?svg=true)](https://ci.appveyor.com/project/shipengcheng1230/gmshtools-jl/branch/master)
[![codecov](https://codecov.io/gh/shipengcheng1230/GmshTools.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/shipengcheng1230/GmshTools.jl)
[![Coverage Status](https://coveralls.io/repos/github/shipengcheng1230/GmshTools.jl/badge.svg?branch=master)](https://coveralls.io/github/shipengcheng1230/GmshTools.jl?branch=master)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://shipengcheng1230.github.io/GmshTools.jl/stable/)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://shipengcheng1230.github.io/GmshTools.jl/latest/)

To use [Gmsh](http://gmsh.info/) mesh program.

# Notice

- Since Gmsh SDK **v4.2.3**, `dlopen` will cause segment fault. So this package will ship with **v4.2.2**. Users who would like try the newest version could set
  the environment `GMSH_LIB_PATH` to your source-compiled Gmsh library directory and rebuild this package. This needs only to be done once.
  An example of building Gmsh SDK would be
  `cmake -DENABLE_BUILD_DYNAMIC=1 -DCMAKE_INSTALL_PREFIX=/opt/gmsh -DOCC_INC=/opt/occ/include/opencascade -DCMAKE_PREFIX_PATH=/opt/occ -DENABLE_FLTK=0 ..`
  provided that you've install (Opencascade)[https://www.opencascade.com/content/latest-release] if you wish use OCC kernel.

- To come along nicely with Intel MKL, the Julia must be compiled with 32 integer interface, i.e. linking to **lp64** instead of **ipl64**.
