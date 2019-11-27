using Documenter, CameraModels

makedocs(
    modules = [CameraModels],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "yakir12",
    sitename = "CameraModels.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/yakir12/CameraModels.jl.git",
)
