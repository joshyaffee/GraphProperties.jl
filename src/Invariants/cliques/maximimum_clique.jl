
"""
    compute(::Type{MaximumClique}, g::AbstractGraph{T}; optimizer=HiGHS.Optimizer)

Return the [maximum clique](https://en.wikipedia.org/wiki/Clique_problem) of `g`.

A [clique](https://en.wikipedia.org/wiki/Clique_(graph_theory)) of a graph `g` is a
subset of the vertices of `g` such that every two distinct vertices in the clique are
adjacent. A maximum clique is a clique of the largest possible size.

# Arguments

- `g::AbstractGraph{T}`: The graph to compute the maximum clique of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the maximum clique
  problem.

# Returns

- A `MaximumClique` object representing the maximum clique of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> compute(MaximumClique, g)
MaximumClique([1, 5])
```
"""
function compute(
    ::Type{MaximumClique},
    g::AbstractGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer

    # Instantiate the model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    n = Graphs.nv(g)

    # Decision variable for each vertex.
    @variable(model, x[1:n], Bin)

    # Objective: maximize the size of the clique.
    @objective(model, Max, sum(x[i] for i=1:n))

    # Constraints to ensure that non-adjacent vertices are not both in the clique.
    for u in 1:n
        for v in (u+1):n
            if !has_edge(g, u, v)
                @constraint(model, x[u] + x[v] <= 1)
            end
        end
    end

    # Solve the model
    optimize!(model)

    # Extract the solution
    clique = [v for v in 1:n if value(x[v]) > 0.5]

    return MaximumClique(clique)
end