module Remark

import Literate
import Documenter, DocumenterMarkdown
import DefaultApplication
import JSON
using Random
using Glob: glob

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

const style_css = joinpath(_pkg_assets, "style.css")

function slideshow(presentation_dir;
    title="Title", documenter=true, options=Dict())

    @assert isdir(presentation_dir)
    presentation_dir = realpath(abspath(presentation_dir))
    indices = ["index.md", "index.jl"]
    indices_path = filter(ispath, joinpath.(presentation_dir, "src", indices))
    length(indices_path) == 1 || error("Exactly one of index.md and index.jl must be present")
    inputfile = indices_path[1]
    
    css_file = joinpath(presentation_dir, "src", "style.css")
    css_dir = joinpath(presentation_dir, "src", "style")
    css_list = isfile(css_file) ? [css_file] :
               isdir(css_dir) ? glob("*.css", css_dir) : [style_css]

    assets_dir = joinpath(dirname(inputfile), "assets")

    # We do all the creation of files in a workingdir in a tempdir, then move them to
    # output dir at the end. We do this because some operations e.g. Documenter will
    # delete the old files before the new ones are created, leaving no file there for
    # several seconds. This breaks auto-refresh web-dev tools as they reload and then
    # can't find the file they are reloading, and not find the file means they have no
    # reload script afterwards, so stop working.
    # to solve this we move everything in place at the end as a single fast operation
    mktempdir() do workingdir
        mkpath.(joinpath.(workingdir, ("src", "build")))
        mk_file = _create_index_md(inputfile, workingdir; documenter=documenter)
        _create_index_html(workingdir, mk_file, options; title=title)
        Base.open(joinpath(workingdir, "build", "style.css"), "w") do io
            foreach(file -> Base.open(content -> write(io, content), file), css_list)
        end
        isdir(assets_dir) && cp(assets_dir, joinpath(workingdir, "build", "assets"), force=true)
        mv(joinpath(workingdir, "build"), joinpath(presentation_dir, "build"), force=true)
    end
    return presentation_dir
end

function _create_index_md(inputfile, outputdir; documenter=true)
    if occursin(r".jl$", inputfile)
        Literate.markdown(inputfile, joinpath(outputdir, "src"), name="index")
    else
        cp(inputfile, joinpath(outputdir, "src", "index.md"), force=true)
    end

    s1 = randstring('a':'z', 50)
    s2 = randstring('a':'z', 50)
    outputfile = joinpath(outputdir, "build", "index.md")
    if documenter
        replace_linewise(
            joinpath(outputdir, "src", "index.md"),
            r"^(\s)*(--)(\s)*$" => s1,
            r"^(\s)*(\$\$)(\s)*$" => s2,
        )
        Documenter.makedocs(format=DocumenterMarkdown.Markdown(), root=outputdir)
        replace_linewise(
            outputfile,
            Regex("^($s1)\$") => "--",
            s2 => raw"$$",
            r"^<a id=.*$" => "",
        )
    else
        cp(joinpath(outputdir, "src", "index.md"), outputfile, force=true)
    end
    outputfile
end

function _create_index_html(outputdir, md_file, options=Dict(); title="Title")

    optionsjs = JSON.json(options)
    template = joinpath(_pkg_assets, "indextemplate.html")
    replacements = ["\$title" => title, "\$options" => optionsjs]

    Base.open(joinpath(outputdir, "build", "index.html"), "w") do io
        for line in eachline(template, keep=true)
            if occursin("\$presentation", line)
                Base.open(md -> write(io, md), md_file)
            else
                write(io, foldl(replace, replacements, init=line))
            end
        end
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

function replace_linewise(filename, pairs...)
    f = Base.open(filename)
    (tmp, tmpstream) = mktemp()
    for line in eachline(f, keep=false)
        newline = foldl(replace, pairs, init=line)
        write(tmpstream, newline)
        write(tmpstream, '\n')
    end
    close(f)
    close(tmpstream)
    mv(tmp, filename, force=true)
end

end # module
