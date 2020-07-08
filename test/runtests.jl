using Remark
using Test
# set GR environment variables
ENV["GKSwstype"] = "100"

demo = joinpath(@__DIR__, "..", "demo")
isdir(demo) && rm(demo, recursive = true)
sleep(1)

mkdir(demo)
cp(joinpath(@__DIR__, "..", "examples"), demo, force=true)
sleep(1)

@testset "deps" begin
    for fn in ["remark.min.js", "katex.min.js", "katex.min.css", "auto-render.min.js"]
        @test isfile(joinpath(@__DIR__, "..", "assets", fn))
    end
end

const katexfonts = [
    "KaTeX_AMS-Regular",
    "KaTeX_Caligraphic-Bold",
    "KaTeX_Caligraphic-Regular",
    "KaTeX_Fraktur-Bold",
    "KaTeX_Fraktur-Regular",
    "KaTeX_Main-Regular",
    "KaTeX_Main-Bold",
    "KaTeX_Main-Italic",
    "KaTeX_Main-BoldItalic",
    "KaTeX_Math-Italic",
    "KaTeX_Math-BoldItalic",
    "KaTeX_SansSerif-Bold",
    "KaTeX_SansSerif-Italic",
    "KaTeX_SansSerif-Regular",
    "KaTeX_Script-Regular",
    "KaTeX_Size1-Regular",
    "KaTeX_Size2-Regular",
    "KaTeX_Size3-Regular",
    "KaTeX_Size4-Regular",
    "KaTeX_Typewriter-Regular",
]

const exts =["ttf", "woff", "woff2"]

@testset "katexfonts" begin
    for font in katexfonts
        for ext in exts
            @test isfile(joinpath(@__DIR__, "..", "assets", "fonts", join([font, ext], '.')))
        end
    end
end

isalnum(x) = isnumeric(x) || isletter(x)

@testset "slideshow" begin
    jl_demo = joinpath(demo, "julia")
    slideshowdir = Remark.slideshow(jl_demo)
    @test slideshowdir == realpath(abspath(jl_demo))
    @test all(isdir, joinpath.(slideshowdir, "build", "fonts", ["Lora", "Ubuntu_Mono", "Yanone_Kaffeesatz"]))
    for file in Remark.depfiles
        @test isfile(joinpath(slideshowdir, "build", splitdir(file)[2]))
    end
    v1 = filter(isalnum, read(joinpath(@__DIR__, "indexjl.html"), String))
    v2 = filter(isalnum, read(joinpath(jl_demo, "build", "index.html"), String))
    @test split(v1, "statplotsvg")[1] == split(v2, "statplotsvg")[1]
    @test split(v1, "textarea")[3] == split(v2, "textarea")[3]
end

@testset "slideshowmd" begin
    md_demo = joinpath(demo, "markdown")
    slideshowdir = Remark.slideshow(md_demo)
    @test slideshowdir == realpath(abspath(md_demo))
    @test all(isdir, joinpath.(slideshowdir, "build", "fonts", ["Lora", "Ubuntu_Mono", "Yanone_Kaffeesatz"]))
    for file in Remark.depfiles
        @test isfile(joinpath(slideshowdir, "build", splitdir(file)[2]))
    end
    v1 = filter(isalnum, read(joinpath(@__DIR__, "indexmd.html"), String))
    v2 = filter(isalnum, read(joinpath(md_demo, "build", "index.html"), String))
    @test split(v1, "statplotsvg")[1] == split(v2, "statplotsvg")[1]
    @test split(v1, "textarea")[3] == split(v2, "textarea")[3]
end

rm(demo, recursive = true)
