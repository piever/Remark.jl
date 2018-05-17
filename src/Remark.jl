module Remark

const _pkg_assets = joinpath(dirname(@__DIR__), "assets")

const deps = [
    "https://fonts.googleapis.com/css?family=Yanone+Kaffeesatz",
    "https://fonts.googleapis.com/css?family=Droid+Serif:400,700,400italic",
    "https://fonts.googleapis.com/css?family=Ubuntu+Mono:400,700,400italic",
    "http://gnab.github.io/remark/downloads/remark-latest.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.5.1/katex.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.5.1/contrib/auto-render.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.5.1/katex.min.css"
]

const depfiles = joinpath.(_pkg_assets, ["font1.css", "font2.css", "font3.css", "remark.min.js", "katex.min.js", "auto-render.min.js", "katex.min.css"])

const depkeys = ["\$font1", "\$font2", "\$font3", "\$remark", "\$katexjs", "\$auto-render", "\$katexcss"]

function slideshow(inputfile, slideshowdir; js = :local)
    mkpath(slideshowdir)
    _create_index_html(slideshowdir; js = js)
    cp(inputfile, joinpath(slideshowdir, "index.md"), remove_destination=true)
    return slideshowdir
end

function _create_index_html(slideshowdir; js = :local)

    d = (js == :local) ? depfiles : deps

    Base.open(joinpath(slideshowdir, "index.html"), "w") do f
        template = Base.open(joinpath(_pkg_assets, "indextemplate.html"))
        for line in eachline(template, chomp=false)
            for (key, val) in zip(depkeys, d)
                line = replace(line, key, val)
            end
            write(f, line)
        end
        close(template)
    end
end

function openurl(url::AbstractString)
    if is_apple()
        run(`open $url`)
    elseif is_windows()
        run(`start $url`)
    elseif is_unix()
        run(`xdg-open $url`)
    end
end

function open(slideshowdir)
    openurl(joinpath(slideshowdir, "index.html"))
end

end # module
