"""
    chromatic_number(g::AbstractGraph{T}, optimizer = HiGHS.Optimizer) where T <: Integer

Return the chromatic number of `g`.

# Arguments

- `g::AbstractGraph{T}`: The graph to compute the chromatic number of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the minimum proper coloring
  problem.

# Returns

- The chromatic number of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = SimpleGraph(5)
{5, 0} undirected simple Int64 graph

julia> add_edge!(g, 1, 2);

julia> add_edge!(g, 1, 3);

julia> add_edge!(g, 1, 4);

julia> add_edge!(g, 1, 5);

julia> chromatic_number(g)
2
```
"""

function chromatic_number(
    g::SimpleGraph{T};
    optimizer = HiGHS.Optimizer
) where T <: Integer

    min_prop_coloring = compute(MinimumProperColoring, g; optimizer=optimizer)
    return length(unique(values(min_prop_coloring.mapping)))
end
