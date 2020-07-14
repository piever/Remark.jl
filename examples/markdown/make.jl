using Remark, FileWatching

while true
    Remark.slideshow(@__DIR__; options = Dict("ratio" => "16:9"), title = "Presentation")
    @info "Rebuilt"
    FileWatching.watch_folder(joinpath(@__DIR__, "src"))
end