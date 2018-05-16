module Remark

using PyCall
import Literate: filename

@pyimport webbrowser

const _pkg_assets = joinpath(dirname(@__DIR__), "assets")

function slideshow(inputfile, outputdir =""; name = filename(inputfile))
    slideshowdir = joinpath(outputdir, name)
    mkpath(slideshowdir)
    _create_index(slideshowdir)
    cp(inputfile, joinpath(slideshowdir, "markdown.md"), remove_destination=true)
    return slideshowdir
end

function _create_index(slideshowdir)
    d = Dict("\$font1" => "url(https://fonts.googleapis.com/css?family=Yanone+Kaffeesatz)",
             "\$font2" => "url(https://fonts.googleapis.com/css?family=Droid+Serif:400,700,400italic)",
             "\$font3" => "url(https://fonts.googleapis.com/css?family=Ubuntu+Mono:400,700,400italic)",
             "\$remark" => "http://gnab.github.io/remark/downloads/remark-latest.min.js",
             "\$ajax" => "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS_HTML&delayStartupUntil=configured")
    s = readstring(joinpath(_pkg_assets, "indextemplate.html"))
    for (key, val) in d
        s = replace(s, key, val)
    end
    Base.open(joinpath(slideshowdir, "index.html"), "w") do f
      write(f, s)
    end
end

function open(slideshowdir)
    webbrowser.open(joinpath(slideshowdir, "index.html"))
end

end # module
