using BinaryProvider

const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))

products = Product[
    LibraryProduct(prefix, "libgmsh", :libgmsh),
]

bin_prefix = "http://gmsh.info/bin"
version = "4.2.2"

download_info = Dict(
    Linux(:i686, :glibc) => ("$bin_prefix/Linux/gmsh-$version-Linux32-sdk.tgz", "58e7fdf9dbc83332bd661d19c8699ff0628d55737f63d383cbb07411cb7b3b06"),
    Linux(:x86_64, :glibc) => ("$bin_prefix/Linux/gmsh-$version-Linux64-sdk.tgz", "ea6a6d36da41b9e777111e055c416ffe994d57c7e3debf174b98e4c09b3b33d7"),
    Windows(:i686) => ("$bin_prefix/Windows/gmsh-$version-Windows32-sdk.zip", "3dcfd09a8ed676f45a21a19ced7eaa49e30e7d4bc0afa1ebf3a334faf226aa04"),
    Windows(:x86_64) => ("$bin_prefix/Windows/gmsh-$version-Windows64-sdk.zip", "a140be41eb0cfb2dcf419a9dc623b1c8f54fd35b24c9cf2c0117fe2354c4df17"),
    MacOS(:x86_64) => ("$bin_prefix/MacOSX/gmsh-$version-MacOSX-sdk.tgz", "29ed2d782f4f62b1f93af37068e7d259843f5a47073c1fcd89a93357d13785d9"),
)

if any(!satisfied(p; verbose=verbose) for p in products)
    try
        # Download and install binaries
        url, tarball_hash = choose_download(download_info)
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)

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

    write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
end
