import BinaryProvider

const _pkg_assets = joinpath(dirname(@__DIR__), "assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

download(
    "http://gnab.github.io/remark/downloads/remark-latest.min.js",
    joinpath(_pkg_assets, "remark.min.js")
)

const tmp = joinpath(_pkg_assets, "tmp")
!isdir(tmp) && mkdir(tmp)

download("https://github.com/KaTeX/KaTeX/releases/download/v0.10.0/katex.tar.gz", joinpath(tmp, "katex.tar.gz"))

BinaryProvider.gen_unpack_cmd(joinpath(tmp, "katex.tar.gz"), tmp) |> run

const katexdir = joinpath(tmp, "katex")
const katexfontdir = joinpath(katexdir, "fonts")

for font in readdir(katexfontdir)
    mv(joinpath(katexfontdir, font), joinpath(_pkg_assets, "fonts", font), force = true)
end

for file in ["katex.min.js", "katex.min.css", joinpath("contrib", "auto-render.min.js")]
    mv(joinpath(katexdir, file), joinpath(_pkg_assets, splitdir(file)[2]), force = true)
end

rm(tmp, recursive=true)
