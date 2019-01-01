module Remark

import Literate
import Documenter, DocumenterMarkdown
import DefaultApplication
using Random

export slideshow

const _pkg_assets = joinpath(dirname(@__DIR__), "assets")

const deps = [
    "http://gnab.github.io/remark/downloads/remark-latest.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/contrib/auto-render.min.js",
    "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0/katex.min.css"
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
    cp(css, joinpath(outputdir, "build", "styles.css"), force=true)
    rm(mk_file)
    return outputdir
end

function _create_index_md(inputfile, outputdir; documenter = true)
    if occursin(r".jl$", inputfile)
        Literate.markdown(inputfile, joinpath(outputdir, "src"), name = "index")
    else
        cp(inputfile, joinpath(outputdir, "src", "index.md"), force=true)
    end

    s1 = randstring('a':'z', 50)
    s2 = randstring('a':'z', 50)
    outputfile = joinpath(outputdir, "build", "index.md")
    if documenter
        _replace_line(joinpath(outputdir, "src", "index.md"), r"^(\s)*(--)(\s)*$", s1)
        _replace_line(joinpath(outputdir, "src", "index.md"), r"^(\s)*(\$\$)(\s)*$", s2)
        Documenter.makedocs(format = DocumenterMarkdown.Markdown(), root = outputdir)
        _replace_line(outputfile, Regex("^($s1)\$"), "--")
        _replace_line(outputfile, s2, "\$\$")
        _replace_line(outputfile, r"^<a id=.*$", "")
    else
        cp(joinpath(outputdir, "src", "index.md"), outputfile, force=true)
    end
    outputfile
end


function _create_index_html(outputdir, md_file)

    Base.open(joinpath(outputdir, "build", "index.html"), "w") do f
        template = Base.open(joinpath(_pkg_assets, "indextemplate.html"))
        for line in eachline(template, keep=true)
            occursin(r"^(\s)*sfTiCgvZnilxkAh6ccwvfYSrKb4PmBKK", line) ? copytobuffer!(f, md_file) : write(f, line)
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

open(outputdir) =
    DefaultApplication.open(joinpath(outputdir, "build", "index.html"))

function copytobuffer!(f, filename)
    for line in eachline(filename, keep=true)
        write(f, line)
    end
end

function _replace_line(filename, a, b)
    f = Base.open(filename)
    (tmp, tmpstream) = mktemp()
    for line in eachline(f, keep=false)
        write(tmpstream, replace(line, a => b))
        write(tmpstream, '\n')
    end
    close(f)
    close(tmpstream)
    mv(tmp, filename, force=true)
end


end # module
