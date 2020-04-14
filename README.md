# Remark

[![Build Status](https://travis-ci.org/piever/Remark.jl.svg?branch=master)](https://travis-ci.org/piever/Remark.jl)
[![codecov.io](http://codecov.io/github/piever/Remark.jl/coverage.svg?branch=master)](http://codecov.io/github/piever/Remark.jl?branch=master)

A simple Julia package to create presentations from markdown using [Remark](https://github.com/gnab/remark).

## Example use

To install type the following command in the Julia Pkg REPL

```julia
(v1.0) pkg> add Remark
```

Check out the [Remark docs](https://github.com/gnab/remark/wiki/Markdown) on how to write the markdown for a Remark slideshow. The most important thing is to use `---` to separate slides; an example markdown file can be found [here](https://github.com/piever/Remark.jl/blob/master/examples/example.md).

```julia
import Remark

# Generate a presentation (html+markdown) from the markdown file "example.md"
# and save it in the folder "presentation/mybeautifulslides".
slideshowdir = Remark.slideshow("example.md", "presentation/mybeautifulslides",
                                options = Dict("ratio" => "16:9"))

# Open presentation in default browser.
Remark.open(slideshowdir)
```

## Features

- The `slideshow` command creates a slideshow that uses local javascript libraries: the resulting presentation folder can be opened offline.

- Using the [Literate](https://github.com/fredrikekre/Literate.jl) package, it is possible to create a presentation from a Julia script. As explained in the Literate documentation, add a comment to slides corresponding to markdown. A slide separator is now `# ---` for example.

- [Documenter](https://github.com/JuliaDocs/Documenter.jl) is run on the markdown by default: to keep the markdown as is, use `documenter=false`.

- All features of Documenter are automatically available here, for example use `# hide` at the end of a line of code for it to not appear in the slideshow (useful for saving plots, see [example](https://github.com/piever/Remark.jl/blob/master/examples/example.md)).
