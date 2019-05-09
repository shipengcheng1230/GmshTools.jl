using BinaryProvider
using SHA

const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))

products = Product[
    LibraryProduct(prefix, "libgmsh", :libgmsh),
]

bin_prefix = "http://gmsh.info/bin"
version = "4.3.0"

download_info = Dict(
    Linux(:i686, :glibc) => ("$bin_prefix/Linux/gmsh-$version-Linux32-sdk.tgz", "703c997f63177a3b15e72dca63d3db46a575d4cb7e41ca860f3d27623b0efed7"),
    Linux(:x86_64, :glibc) => ("$bin_prefix/Linux/gmsh-$version-Linux64-sdk.tgz", "3cee6e84e6e2f9cfb69b9041d65db58ba0eb4b5aa7e6fcc72fd0485d40e46fe6"),
    Windows(:i686) => ("$bin_prefix/Windows/gmsh-$version-Windows32-sdk.zip", "88b6d5d3aa77ee45514731aa8a105a070807a703166f187e41229277fc0c53f4"),
    Windows(:x86_64) => ("$bin_prefix/Windows/gmsh-$version-Windows64-sdk.zip", "632f208d00fbb42204358a92f2bc9af1eb38cf98732ff4bbf206f3a6f7193677"),
    MacOS(:x86_64) => ("$bin_prefix/MacOSX/gmsh-$version-MacOSX-sdk.tgz", "5342ca82a1cae0734fdf189bb98fbc58199ed4e462328b514ad04dbef356b715"),
)

if any(!satisfied(p; verbose=verbose) for p in products)
    try
        # Download and install binaries
        url, tarball_hash = choose_download(download_info)
        try
            install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
        catch e
            tarball_path = joinpath(prefix, "downloads", basename(url))
            run(pipeline(`unzip $tarball_path -d $(prefix.path)`))
        end

        content_path = joinpath(prefix, splitext(basename(url))[1])
        foreach(
            (x) -> mv(joinpath(content_path, x), joinpath(prefix, x); force=true),
            readdir(content_path)
            )
        rm(content_path; force=true, recursive=true)
    catch e
        if typeof(e) <: ArgumentError
            error("Your platform $(Sys.MACHINE) is not supported by this package!")
        else
            rethrow(e)
        end
    end

    # write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
end
