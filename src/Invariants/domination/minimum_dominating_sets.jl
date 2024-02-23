"""
    compute(
        ::Type{MinimumDominatingSet},
        g::AbstractGraph{T};
        optimizer=HiGHS.Optimizer
    ) where T <: Integer

Return a minimum dominating set of `g`.

A [dominating set](https://en.wikipedia.org/wiki/Dominating_set) of a graph `g` is a
subset `S` of the vertices of `g` such that every vertex not in `S` is adjacent to at
least one member of `S`. A dominating set is said to be minimum if it has the smallest
possible cardinality among all dominating sets of `g`.

# Arguments

- `g::AbstractGraph{T}`: The graph to compute the minimum dominating set of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the minimum dominating set
  problem.

# Returns

- A `MinimumDominatingSet` object representing the minimum dominating set of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> compute(MinimumDominatingSet, g)
MinimumDominatingSet([2, 5])
```
"""
function compute(
    ::Type{MinimumDominatingSet},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer

    # Instantiate the model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    # The number of vertices.
    n = Graphs.nv(g)

    # Decision variable for each vertex.
    @variable(model, x[1:n], Bin)

    # Objective: minimize the size of the dominating set.
    @objective(model, Min, sum(x[i] for i=1:n))

    # Constraints: each vertex must either be in the dominating set or adjacent to a vertex in the set
    for u in 1:n
        neighbors_u = neighbors(g, u)
        @constraint(model, x[u] + sum(x[v] for v in neighbors_u) >= 1)
    end

    # Solve the model
    optimize!(model)

    # Extract the solution
    dominating_set = [v for v in 1:n if value(x[v]) == 1.0]

    return MinimumDominatingSet(dominating_set)
end

"""
    compute(
        ::Type{MinimumTotalDominatingSet},
        g::SimpleGraph{T};
        optimizer=HiGHS.Optimizer
    ) where T <: Integer

Return a minimum total dominating set of `g`.

A [total dominating set](https://en.wikipedia.org/wiki/Total_dominating_set) of a graph `g` is a
subset `S` of the vertices of `g` such that every vertex in `g` is adjacent to at
least one member of `S`. A total dominating set is said to be minimum if it has the smallest
possible cardinality among all total dominating sets of `g`.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the minimum total dominating set of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the optimization problem.

# Returns

- A `MinimumTotalDominatingSet` object representing the minimum total dominating set of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> compute(MinimumTotalDominatingSet, g)
MinimumTotalDominatingSet([2, 3, 4])
```
"""
function compute(
    ::Type{MinimumTotalDominatingSet},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer

    # Instantiate the model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    # The number of vertices.
    n = Graphs.nv(g)

    # Decision variable for each vertex.
    @variable(model, x[1:n], Bin)

    # Objective: minimize the size of the dominating set.
    @objective(model, Min, sum(x[i] for i=1:n))

    # Constraints: each vertex must either be in the dominating set or adjacent to a vertex in the set
    for u in 1:n
        neighbors_u = Graphs.neighbors(g, u)
        @constraint(model, sum(x[v] for v in neighbors_u) >= 1)
    end

    # Solve the model
    optimize!(model)

    # Extract the solution
    dominating_set = [v for v in 1:n if value(x[v]) == 1.0]

    return MinimumTotalDominatingSet(dominating_set)
end

# TODO: has this been tested?
function compute(
    ::Type{MinimumLocatingDominatingSet},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer

    # Instantiate the model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    n = nv(g)

    # Decision variable for each vertex.
    @variable(model, x[1:n], Bin)

    # Decision variable to identify which dominator is responsible for a vertex.
    @variable(model, z[1:n, 1:n], Bin)

    # Objective: minimize the size of the dominating set.
    @objective(model, Min, sum(x[i] for i=1:n))

    # Constraints ensuring every vertex is dominated.
    for v in 1:n
        @constraint(model, sum(z[v, u] for u in 1:n) == 1)
        for u in 1:n
            if u == v || has_edge(g, u, v)
                @constraint(model, z[v, u] <= x[u])
            else
                @constraint(model, z[v, u] == 0)
            end
        end
    end

    # Solve the model
    optimize!(model)

    # Extract the solution
    locating_dominating_set = [v for v in 1:n if value(x[v]) == 1.0]

    return MinimumLocatingDominatingSet(locating_dominating_set)
end

# TODO: has this been tested?
function compute(
    ::Type{MinimumPairedDominatingSet},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer

    # Instantiate the model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    n = Graphs.nv(g)

    # Decision variable for each vertex.
    @variable(model, x[1:n], Bin)

    # Decision variable for each pair.
    @variable(model, z[1:n, 1:n], Bin)

    # Objective: minimize the size of the paired dominating set.
    @objective(model, Min, sum(z[i,j] for i=1:n for j=1:n))

    # Constraints for the pairs.
    for i in 1:n
        for j in 1:n
            @constraint(model, z[i, j] <= x[i])
            @constraint(model, z[i, j] <= x[j])
        end
    end

    # Ensure each vertex is covered by a pair.
    for v in 1:n
        @constraint(model, sum(z[i, j] for i=1:n for j=1:n if i != v && j != v) >= 1)
    end

    # Solve the model
    optimize!(model)

    # Extract the solution
    paired_dominating_set = [v for v in 1:n if value(x[v]) == 1.0]

    return MinimumPairedDominatingSet(paired_dominating_set)
end

# TODO: has this been tested?
function compute(
    ::Type{MinimumIndependentDominatingSet},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer

    # Instantiate the model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    # The number of vertices.
    n = Graphs.nv(g)

    # Decision variable for each vertex.
    @variable(model, x[1:n], Bin)

    # Objective: minimize the size of the dominating set.
    @objective(model, Min, sum(x[i] for i=1:n))

    # Constraints: each vertex must either be in the dominating set or adjacent to a vertex in the set
    for u in 1:n
        neighbors_u = Graphs.neighbors(g, u)
        @constraint(model, x[u] + sum(x[v] for v in neighbors_u) >= 1)
    end

    # Constraints: insure that no two vertices in the dominating set are adjacent
    for u in 1:n
        for v in (u+1):n
            if Graphs.has_edge(g, u, v)
                @constraint(model, x[u] + x[v] <= 1)
            end
        end
    end

    # Solve the model
    optimize!(model)

    # Extract the solution
    dominating_set = [v for v in 1:n if value(x[v]) == 1.0]

    return MinimumIndependentDominatingSet(dominating_set)
end

"""
    compute(::Type{MinimumEdgeDominatingSet}, g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)

Return a minimum edge dominating set of `g`.

An [edge dominating set](https://en.wikipedia.org/wiki/Edge_dominating_set) of a graph `g`
is a subset `S` of the edges of `g` such that every edge in `g` is either in `S` or
adjacent to an edge in `S`. A minimum edge dominating set is an edge dominating set of
smallest possible cardinality.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the minimum edge dominating set of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the optimization problem.

# Returns

- A `MinimumEdgeDominatingSet` object representing the minimum edge dominating set of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> compute(MinimumEdgeDominatingSet, g)
MinimumEdgeDominatingSet(Graphs.SimpleGraphs.SimpleEdge{Int64}[Edge 1 => 5, Edge 2 => 3])
```
"""
function compute(
    ::Type{MinimumEdgeDominatingSet},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer

    # Instantiate the model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    # The edge set of the graph.
    E = Graphs.edges(g)

    # Decision variable for each edge.
    @variable(model, x[E], Bin)

    # Objective: Minimize the number of edges in the MEDS
    @objective(model, Min, sum(x[e] for e in E))

    # Constraints: Each edge or at least one of its adjacent edges is in the MEDS
    for e in E
        u, v = Graphs.src(e), Graphs.dst(e)
        adjacent_edges = [
            e2 for e2 in E
            if (e2 != e) &&
                (
                    src(e2) == u ||
                    dst(e2) == u ||
                    src(e2) == v ||
                    dst(e2) == v
                )
        ]
        @constraint(model, x[e] + sum(x[e2] for e2 in adjacent_edges) >= 1)
    end

    # Solve the model.
    optimize!(model)

    # Extract the solution.
    return MinimumEdgeDominatingSet([e for e in E if value(x[e]) == 1.0])
end


"""
    compute(::Type{MinimumZeroForcingSet}, g::SimpleGraph)

Return a minimum zero forcing set of `g`.

"""
function compute(
    ::Type{MinimumPowerDominatingSet},
    g::SimpleGraph{T}
) where T <: Integer

    # The number of vertices.
    n = Graphs.nv(g)

    for size in 1:n
        for subset in Combinatorics.combinations(1:n, size)
            blue = Set(subset)
            apply!(DominationRule, blue, g)
            apply!(ZeroForcingRule, blue, g; max_iter=n)
            length(blue) == n && return MinimumPowerDominatingSet(subset)
        end
    end
    return []
end
