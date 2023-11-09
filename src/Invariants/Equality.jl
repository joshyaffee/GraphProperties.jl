using Graphs

"""
equals method for undirected edges::Union{Vector{Tuple{Int, Int}}, Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}}
"""
function equals(
    a::Union{Vector{Tuple{Int, Int}}, Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}},
    b::Union{Vector{Tuple{Int, Int}}, Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}}
)

    # convert a to an array of tuples
    if typeof(a) == Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}
        a = [(min(e.src, e.dst), max(e.src, e.dst)) for e in a]
    else
        a = [(min(e[1], e[2]), max(e[1], e[2])) for e in a]
    end

    # convert b to an array of tuples
    if typeof(b) == Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}
        b = [(min(e.src, e.dst), max(e.src, e.dst)) for e in b]
    else
        b = [(min(e[1], e[2]), max(e[1], e[2])) for e in b]
    end

    # check if the lengths are equal
    if length(a) != length(b)
        return false
    end

    # check if the edges are equal
    for e in a
        if !(e in b)
            return false
        end
    end

    return true
end

# g = Graphs.PetersenGraph()
# edge_set1 = [(1,5), (7,9), (8,3)]
# edge_set2 = [(5,4), (6,8), (7,2)]
# println(equals(edge_set1, edge_set2))