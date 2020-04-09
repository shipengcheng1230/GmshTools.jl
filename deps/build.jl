using BinaryProvider

const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
const libname = Sys.iswindows() ? "gmsh-4.5" : "libgmsh"

products = Product[
    LibraryProduct(prefix, libname, :libgmsh),
]

bin_prefix = "http://gmsh.info/bin"
version = "4.5.6"

download_info = Dict(
    Linux(:x86_64, :glibc) => ("$bin_prefix/Linux/gmsh-$version-Linux64-sdk.tgz", "c758bb820365351352542a0575d673f037e3af58cbd7b3549a0c9d9d02b9a53c"),
    Windows(:x86_64) => ("$bin_prefix/Windows/gmsh-$version-Windows64-sdk.zip", "b8c704712347b235af857a5aec4501c9f27e8d1ec305a0dba898500cd8032d03"),
    MacOS(:x86_64) => ("$bin_prefix/MacOSX/gmsh-$version-MacOSX-sdk.tgz", "bdf1df022e663c0249f8553137844449726c1776a84ef75bbb3b53457f3716bc"),
)

if haskey(ENV, "GMSH_LIB_PATH")
    products = Product[LibraryProduct(ENV["GMSH_LIB_PATH"], libname, :libgmsh),]
    write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
else
    if any(!satisfied(p; verbose=verbose) for p in products)
        try
            # download and install binaries
            url, tarball_hash = choose_download(download_info)
            try
                install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
            catch e
                # cannot list content of .zip, manually unzip
                tarball_path = joinpath(prefix, "downloads", basename(url))
                run(`unzip $(tarball_path) -d $(prefix.path)`)
            end

            # strip the top directory
            content_path = joinpath(prefix, splitext(basename(url))[1])
            foreach(
                (x) -> mv(joinpath(content_path, x), joinpath(prefix, x); force=true),
                readdir(content_path)
                )
            rm(content_path; force=true, recursive=true)

            # BinaryProvider will search $prefix/bin instead of $prefix/lib
            if Sys.iswindows()
                dir_path = libdir(products[1].prefix, platform_key_abi())
                lib_path = joinpath(dirname(dir_path), "lib")
                run(`cp -L $(lib_path)/* $(dir_path)`)
            end
        catch e
            if typeof(e) <: ArgumentError
                error("Your platform $(Sys.MACHINE) is not supported by this package!")
            else
                rethrow(e)
            end
        end
    end
    write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
end
