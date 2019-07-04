using BinaryProvider

const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))

products = Product[
    LibraryProduct(prefix, "libgmsh", :libgmsh),
]

bin_prefix = "http://gmsh.info/bin"
version = "4.4.0"

download_info = Dict(
    Linux(:x86_64, :glibc) => ("$bin_prefix/Linux/gmsh-$version-Linux64-sdk.tgz", "edbb135813c3406f9fa3cd0e8374c5b4ecd8361aa6637fb14221c3d380a12490"),
    Windows(:x86_64) => ("$bin_prefix/Windows/gmsh-$version-Windows64-sdk.zip", "a0e4fe394debfad6d7236da7548aaed3649c9a6e0c481beb8918e41db931f017"),
    MacOS(:x86_64) => ("$bin_prefix/MacOSX/gmsh-$version-MacOSX-sdk.tgz", "71a1115396e86d97daae3648e2601bf66f4c57f5c3eedbb07c53f76dd2ccb3eb"),
)

if any(!satisfied(p; verbose=verbose) for p in products)
    try
        # Download and install binaries
        url, tarball_hash = choose_download(download_info)
        try
            install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
        catch e
            # cannot list content of .zip, manually unzip
            tarball_path = joinpath(prefix, "downloads", basename(url))
            run(pipeline(`unzip $tarball_path -d $(prefix.path)`))
        end

        # strip the top directory
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
