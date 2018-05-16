module Remark

using PyCall
import Literate: filename

@pyimport webbrowser

const _pkg_assets = joinpath(dirname(@__DIR__), "assets")

function slideshow(inputfile, outputdir =""; name = filename(inputfile))
    slideshowdir = joinpath(outputdir, name)
    mkpath(slideshowdir)
    cp(joinpath(_pkg_assets, "index.html"), joinpath(slideshowdir, "index.html"), remove_destination=true)
    cp(inputfile, joinpath(slideshowdir, "markdown.md"), remove_destination=true)
    return slideshowdir
end

function open(slideshowdir)
    webbrowser.open(joinpath(slideshowdir, "index.html"))
end

end # module
