"""
    matching_number(g::SimpleGraph; optimizer=HiGHS.Optimizer)

Return the [matching number](https://en.wikipedia.org/wiki/Matching_(graph_theory)) of `g`. 

A [matching](https://en.wikipedia.org/wiki/Matching_(graph_theory)) of a graph `g` is a
subset of the edges of `g` such that no two edges in the matching share a vertex. The
matching number of `g` is the cardinality of a maximum matching of `g`.

# Arguments

- `g::SimpleGraph`: The graph to compute the matching number of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the maximum matching
  problem.

# Returns

- The matching number of `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> matching_number(g)
2
```
"""
function matching_number(
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer

    max_ms = compute(MaximumMatching, g; optimizer=optimizer)

    return length(max_ms.edges)
end
