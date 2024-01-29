"""
    function independence_number(
        g::SimpleGraph{T};
        optimizer=Cbc.Optimizer,
    ) where T <: Integer

Return the [independence number](https://en.wikipedia.org/wiki/Independent_set_(graph_theory)) of `g`.

### Implementation Notes
This function relies on `compute` to obtain a maximum independent set of `g`.
The `optimizer` is passed to `max_independent_set`.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the independence number of.

# Keywords

- `optimizer=Cbc.Optimizer`: The optimizer to use to solve the maximum independent set
  problem.

# Returns

- The independence number of `g`.

# Example
```julia
julia> using Graphs

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> independence_number(g)
2
```
"""
function independence_number(
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer,
) where T <: Integer

    max_ind_set = compute(MaximumIndependentSet, g; optimizer=optimizer)

    return length(max_ind_set.nodes)
end
