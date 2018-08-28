using Remark
using Test

demo = realpath(abspath(joinpath(@__DIR__, "..", "demo")))
isdir(demo) && rm(demo, recursive = true)
sleep(1)

mkdir(demo)
filenames = ["example.jl", "example.md"]
cp.(joinpath.(@__DIR__, "..", "examples", filenames), joinpath.(@__DIR__, "..", "demo", filenames), force = true)
sleep(1)

@testset "deps" begin
    @test all(isfile, Remark.depfiles)
end

@testset "slideshow" begin
    slideshowdir = Remark.slideshow(joinpath(demo, "example.jl"))
    @test slideshowdir == demo
    @test all(isdir, joinpath.(slideshowdir, "build", "fonts", ["Lora", "Ubuntu_Mono", "Yanone_Kaffeesatz"]))
    for file in Remark.depfiles
        @test isfile(joinpath(slideshowdir, "build", splitdir(file)[2]))
    end
    v1 = readlines(joinpath(@__DIR__, "index.html"))
    v2 = readlines(joinpath(demo, "build", "index.html"))
    @test all(v1 .== v2)
end

rm(demo, recursive = true)
