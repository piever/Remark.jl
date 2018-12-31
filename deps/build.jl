const _pkg_assets = joinpath(dirname(@__DIR__), "assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

deps = [
    "http://gnab.github.io/remark/downloads/remark-latest.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/contrib/auto-render.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css"
]

depnames = joinpath.(_pkg_assets, ["remark.min.js", "katex.min.js", "auto-render.min.js", "katex.min.css"])

for (dep, depname) in zip(deps, depnames)
    download(dep, depname)
end

include("katexfonts.jl")
