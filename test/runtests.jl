using Remark
using Test

rm(joinpath(@__DIR__, "..", "demo"), force = true, recursive = true)
sleep(1)

mkdir(joinpath(@__DIR__, "..", "demo"))
filenames = ["example.jl", "example.md"]
cp.(joinpath.(@__DIR__, "..", "examples", filenames), joinpath.(@__DIR__, "..", "demo", filenames), force = true)
sleep(1)
# write your own tests here
@testset "deps" begin
    @test all(isfile, Remark.depfiles)
end

@testset "slideshow" begin
    slideshowdir = Remark.slideshow(joinpath(@__DIR__, "..", "demo", "example.jl"))
    @test slideshowdir == realpath(abspath(joinpath(@__DIR__, "..", "demo")))
    @test all(isdir, joinpath.(slideshowdir, "build", "fonts", ["Lora", "Ubuntu_Mono", "Yanone_Kaffeesatz"]))
end
