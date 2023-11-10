using Graphs
const SimpleInt64Edge = Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}

"""
equals method for undirected edges::Union{Vector{Tuple{Int, Int}}, Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}}
"""
function equals(
    a::Union{Vector{Tuple{Int, Int}}, Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}},
    b::Union{Vector{Tuple{Int, Int}}, Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}}
)

    isa(a, SimpleInt64Edge) && a_set = Set([(min(e.src, e.dst), max(e.src, e.dst)) for e in a])
    !isa(a, SimpleInt64Edge) && a_set = Set([(min(e[1], e[2]), max(e[1], e[2])) for e in a])

    isa(b, SimpleInt64Edge) && b_set = Set([(min(e.src, e.dst), max(e.src, e.dst)) for e in b])
    !isa(b, SimpleInt64Edge) && b_set = Set([(min(e[1], e[2]), max(e[1], e[2])) for e in b])

    return a_set == b_set
end