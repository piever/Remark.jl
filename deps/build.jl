const _pkg_assets = joinpath(dirname(@__DIR__), "assets")

!isdir(_pkg_assets) && mkdir(_pkg_assets)

deps = [
    "https://fonts.googleapis.com/css?family=Yanone+Kaffeesatz",
    "https://fonts.googleapis.com/css?family=Droid+Serif:400,700,400italic",
    "https://fonts.googleapis.com/css?family=Ubuntu+Mono:400,700,400italic",
    "http://gnab.github.io/remark/downloads/remark-latest.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.5.1/katex.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.5.1/contrib/auto-render.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.5.1/katex.min.css"
]

depnames = joinpath.(_pkg_assets, ["font1.css", "font2.css", "font3.css", "remark.min.js", "katex.min.js", "auto-render.min.js", "katex.min.css"])

for (dep, depname) in zip(deps, depnames)
    download(dep, depname)
end
