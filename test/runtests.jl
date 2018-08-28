using Remark
using Test

demo = joinpath(@__DIR__, "..", "demo")
isdir(demo) && rm(demo, recursive = true)
sleep(1)

mkdir(demo)
filenames = ["example.jl", "example.md"]
cp.(joinpath.(@__DIR__, "..", "examples", filenames), joinpath.(@__DIR__, "..", "demo", filenames), force = true)
sleep(1)

@testset "deps" begin
    @test all(isfile, Remark.depfiles)
end

isalnum(x) = isnumeric(x) || isletter(x)

@testset "slideshow" begin
    slideshowdir = Remark.slideshow(joinpath(demo, "example.jl"))
    @test slideshowdir == realpath(abspath(demo))
    @test all(isdir, joinpath.(slideshowdir, "build", "fonts", ["Lora", "Ubuntu_Mono", "Yanone_Kaffeesatz"]))
    for file in Remark.depfiles
        @test isfile(joinpath(slideshowdir, "build", splitdir(file)[2]))
    end
    v1 = filter(isalnum, read(joinpath(@__DIR__, "indexjl.html"), String))
    v2 = filter(isalnum, read(joinpath(demo, "build", "index.html"), String))
    @test split(v1, "statplotsvg")[1] == split(v2, "statplotsvg")[1]
    @test split(v1, "textarea")[3] == split(v2, "textarea")[3]
end

@testset "slideshowmd" begin
    slideshowdir = Remark.slideshow(joinpath(demo, "example.md"))
    @test slideshowdir == realpath(abspath(demo))
    @test all(isdir, joinpath.(slideshowdir, "build", "fonts", ["Lora", "Ubuntu_Mono", "Yanone_Kaffeesatz"]))
    for file in Remark.depfiles
        @test isfile(joinpath(slideshowdir, "build", splitdir(file)[2]))
    end
    v1 = filter(isalnum, read(joinpath(@__DIR__, "indexmd.html"), String))
    v2 = filter(isalnum, read(joinpath(demo, "build", "index.html"), String))
    @test split(v1, "statplotsvg")[1] == split(v2, "statplotsvg")[1]
    @test split(v1, "textarea")[3] == split(v2, "textarea")[3]
end

rm(demo, recursive = true)
