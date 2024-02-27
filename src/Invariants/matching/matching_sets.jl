
"""
    compute(::Type{MaximumMatching}, g::SimpleGraph{T}; optimizer=HiGHS.Optimizer) where T <: Integer

Return a maximum matching of `g`.

A [matching](https://en.wikipedia.org/wiki/Matching_(graph_theory)) of a graph `g`
is a subset of the edges of `g` such that no two edges share a common vertex. A matching
is said to be maximum if it has the largest possible cardinality among all matchings of `g`.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute a maximum matching of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the maximum matching
  problem.

# Returns

- A maximum matching of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> compute(MaximumMatching, g)
MaximumMatching(Graphs.SimpleGraphs.SimpleEdge{Int64}[Edge 1 => 2, Edge 3 => 4])
```
"""
function compute(
    ::Type{MaximumMatching},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    # Instantiate the model.
    model = JuMP.Model(optimizer)
    JuMP.set_silent(model)

    # The number of vertices.
    n = Graphs.nv(g)

    # The edge set of the graph.
    E = Graphs.edges(g)

    # Decision variable for each edge.
    @variable(model, x[E], Bin)

    # Objective: maximize the number of edges in the matching.
    @objective(model, Max, sum(x[e] for e in E))

    # Constraints: Each vertex is incident to at most one matched edge
    for v in 1:n
        incident_edges = [e for e in E if Graphs.src(e) == v || Graphs.dst(e) == v]
        @constraint(model, sum(x[e] for e in incident_edges) <= 1)
    end

    # Solve the model.
    optimize!(model)

    # Extract the solution.
    return MaximumMatching([e for e in E if value(x[e]) == 1.0])
end
