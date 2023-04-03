import Tar, CodecZlib, Downloads

const _pkg_assets = joinpath(dirname(@__DIR__), "assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

download(
    "http://gnab.github.io/remark/downloads/remark-latest.min.js",
    joinpath(_pkg_assets, "remark.min.js")
)

mktempdir() do tmp
    katex_compressed=joinpath(tmp, "katex.tar.gz")

    Downloads.download("https://github.com/KaTeX/KaTeX/releases/download/v0.10.0/katex.tar.gz", katex_compressed)

    extract_dir = mkpath(joinpath(tmp, "extract"))
    open(CodecZlib.GzipDecompressorStream, katex_compressed) do io
        Tar.extract(io, extract_dir)
     end

    katexdir = joinpath(extract_dir, "katex")
    katexfontdir = joinpath(katexdir, "fonts")

    for font in readdir(katexfontdir)
        mv(joinpath(katexfontdir, font), joinpath(_pkg_assets, "fonts", font), force = true)
    end

    for file in ["katex.min.js", "katex.min.css", joinpath("contrib", "auto-render.min.js")]
        mv(joinpath(katexdir, file), joinpath(_pkg_assets, splitdir(file)[2]), force = true)
    end
end
