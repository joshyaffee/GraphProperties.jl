"""
    function clique_number(g::AbstractGraph; optimizer=HiGHS.Optimizer)

Return the [clique number](https://en.wikipedia.org/wiki/Clique_problem) of `g`.

A clique of a graph `g` is a subset of the vertices of `g` such that every two distinct
vertices in the clique are adjacent. The clique number of `g` is the cardinality of a
maximum clique of `g`.

# Implementation Notes
Computes the independence number of the complement of `g`.

# Arguments

- `g::AbstractGraph`: The graph to compute the clique number of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the maximum independent set
  problem.
  
# Returns

- The clique number of `g`.

# Example
```julia
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = path_graph(5)
{5, 4} undirected simple Int64 graph

julia> clique_number(g)
2
```
"""
function clique_number(
    g::AbstractGraph{T};
    optimizer=HiGHS.Optimizer,
) where T <: Integer
    h = complement(g)
    return independence_number(h; optimizer=optimizer)
end
