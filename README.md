# Remark

A simple Julia package to create presentations from markdown using [Remark](https://github.com/gnab/remark).

## Example use

To install type the following command in the Julia REPL

```julia
Pkg.clone("https://github.com/piever/Remark.jl.git")
Pkg.build("https://github.com/piever/Remark.jl.git")
```

Check [Remark documentation](https://github.com/gnab/remark/wiki/Markdown) on how to write the markdown for it to work with Remark. The most important thing is to use `---` to separate slides, a tiny example markdown file can be found [here](https://github.com/piever/Remark.jl/blob/master/examples/index.md).

```julia
import Remark

# Add presentation (html+markdown) from the markdown file "index.md" in the folder "presentation/mybeautifulslides"
slideshowdir = Remark.slideshow("index.md", "presentation/mybeautifulslides")

# Open presentation in default browser
Remark.open(slideshowdir)
```

## Offline use

The `slideshow` command creates a slideshow that uses local javascript libraries: the resulting presentation folder can be opened offline. To instead use the online javascript libraries use the option `js=:remote` to the `slideshow` function.

## Using from a Julia script

Using the [Literate](https://github.com/fredrikekre/Literate.jl) package it is possible to create a presentation from a Julia script. As explained in the Literate documentation, add a comment to slides corresponding to markdown. A slide separator is now `# ---` for example.

## Documenter

By default Documenter is run on the provided markdown. To keep the markdown as is, use `documenter=false`.
