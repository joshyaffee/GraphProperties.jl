push!(LOAD_PATH,"../src/")

using Documenter, GraphProperties

makedocs(sitename="GraphProperties.jl", format= format=Documenter.HTML(), pages = [
    "index.md",
    "basics.md",
    "invariants.md",
    "communities.md",
    "degree_sequence_invariants.md",
    "draw.md",
    "graph_rules.md",
    "graph_io.md"]
)