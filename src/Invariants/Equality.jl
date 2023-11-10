
"""
    ==(
        a::AbstractOptimalEdgeSet,
        b::AbstractOptimalEdgeSet
    )::Bool

Determine if two sets of edges are equivalent in an undirected graph context.

This method treats each edge as undirected, meaning the order of vertices in
each edge tuple or `Graphs.SimpleGraphs.SimpleEdge` is ignored. Two sets of edges
are considered equal if they contain the same pairs of vertices, regardless of
the order in which the vertices appear in each edge.

# Arguments
- `a::AbstractOptimalEdgeSet`: The first set of edges to compare.
- `b::AbstractOptimalEdgeSet`: The second set of edges to compare.

# Returns
- `true` if both sets of edges represent the same undirected connections, `false` otherwise.

# Examples
```julia
julia> using Graphs.SimpleGraphs: SimpleEdge

julia> using GraphProperties.Invariants

julia> a = OptimalEdgeSet([SimpleEdge(1, 2), SimpleEdge(2, 3)])

julia> b = OptimalEdgeSet([SimpleEdge(2, 1), SimpleEdge(3, 2)])

julia> a == b
true
```
"""

using Graphs
import Base: ==
using Graphs.SimpleGraphs: SimpleEdge

# Define a helper function to normalize an edge.
function _normalize_edge(edge)
    edge isa Tuple && return (min(edge...), max(edge...))
    return (min(edge.src, edge.dst), max(edge.src, edge.dst))
end

# override the equality operator for AbstractOptimalEdgeSet.
function ==(
    a::AbstractOptimalEdgeSet,
    b::AbstractOptimalEdgeSet
)
    a_set = Set(_normalize_edge(edge) for edge in a.edges)
    b_set = Set(_normalize_edge(edge) for edge in b.edges)

    return a_set == b_set
end