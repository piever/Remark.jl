import Tar, CodecZlib

const _pkg_assets = joinpath(dirname(@__DIR__), "assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

download(
    "http://gnab.github.io/remark/downloads/remark-latest.min.js",
    joinpath(_pkg_assets, "remark.min.js")
)

const tmp = joinpath(_pkg_assets, "tmp")
!isdir(tmp) && mkdir(tmp)

const download_dir = joinpath(_pkg_assets, "download")
!isdir(download_dir) && mkdir(download_dir)

katex_compressed=joinpath(download_dir, "katex.tar.gz")

download("https://github.com/KaTeX/KaTeX/releases/download/v0.10.0/katex.tar.gz", katex_compressed)

open(CodecZlib.GzipDecompressorStream, katex_compressed) do io
   Tar.extract(io, tmp)
end

const katexdir = joinpath(tmp, "katex")
const katexfontdir = joinpath(katexdir, "fonts")

for font in readdir(katexfontdir)
    mv(joinpath(katexfontdir, font), joinpath(_pkg_assets, "fonts", font), force = true)
end

for file in ["katex.min.js", "katex.min.css", joinpath("contrib", "auto-render.min.js")]
    mv(joinpath(katexdir, file), joinpath(_pkg_assets, splitdir(file)[2]), force = true)
end

rm(tmp, recursive=true)
rm(download_dir, recursive=true)
