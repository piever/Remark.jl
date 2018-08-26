module Remark

import Literate
import Documenter

export slideshow

const _pkg_assets = joinpath(dirname(@__DIR__), "assets")

const deps = [
    "http://gnab.github.io/remark/downloads/remark-latest.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.5.1/katex.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.5.1/contrib/auto-render.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.5.1/katex.min.css"
]

const depnames =  ["remark.min.js", "katex.min.js", "auto-render.min.js", "katex.min.css"]
const depfiles = joinpath.(_pkg_assets, depnames)

const styles_css = joinpath(_pkg_assets, "styles.css")

function slideshow(inputfile, outputdir = dirname(inputfile); documenter = true, css = styles_css)
    inputfile = realpath(abspath(inputfile))
    outputdir = realpath(abspath(outputdir))
    css = realpath(abspath(css))
    mkpath.(joinpath.(outputdir, ("src", "build")))
    mk_file = _create_index_md(inputfile, outputdir; documenter = documenter)
    _create_index_html(outputdir, mk_file)
    cp(css, joinpath(outputdir, "build", "styles.css"), remove_destination=true)
    rm(mk_file)
    return outputdir
end

function _create_index_md(inputfile, outputdir; documenter = true)
    if ismatch(r".jl$", inputfile)
        Literate.markdown(inputfile, joinpath(outputdir, "src"), name = "index")
    else
        cp(inputfile, joinpath(outputdir, "src", "index.md"), remove_destination=true)
    end

    srand(123)
    s = randstring(50)
    _replace_line(joinpath(outputdir, "src", "index.md"), r"^(\s)*(--)(\s)*$", s)
    outputfile = joinpath(outputdir, "build", "index.md")
    if documenter
        Documenter.makedocs(root = outputdir)
    else
        cp(joinpath(outputdir, "src", "index.md"), outputfile, remove_destination=true)
    end
    _replace_line(outputfile, Regex("^($s)\$"), "--")
    _replace_line(outputfile, r"^<a id=.*$", "")
    outputfile
end


function _create_index_html(outputdir, md_file)

    Base.open(joinpath(outputdir, "build", "index.html"), "w") do f
        template = Base.open(joinpath(_pkg_assets, "indextemplate.html"))
        for line in eachline(template, chomp=false)
            ismatch(r"^(\s)*sfTiCgvZnilxkAh6ccwvfYSrKb4PmBKK", line) ? copytobuffer!(f, md_file) : write(f, line)
        end
        close(template)
    end
    for (name, file) in zip(depnames, depfiles)
        dest = joinpath(outputdir, "build", name)
        isfile(dest) || cp(file, dest)
    end
    dest = joinpath(outputdir, "build", "fonts")
    isdir(dest) || cp(joinpath(_pkg_assets, "fonts"), dest)
    joinpath(outputdir, "build", "index.html")
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

function open(outputdir)
    openurl(joinpath(outputdir, "build", "index.html"))
end

function copytobuffer!(f, filename)
    for line in eachline(filename, chomp=false)
        write(f, line)
    end
end

function _replace_line(filename, a::Regex, b)
    f = Base.open(filename)
    (tmp, tmpstream) = mktemp()
    for line in eachline(f, chomp = true)
        write(tmpstream, ismatch(a, line) ? b : line)
        write(tmpstream, '\n')
    end
    close(f)
    close(tmpstream)
    mv(tmp, filename, remove_destination = true)
end


end # module
