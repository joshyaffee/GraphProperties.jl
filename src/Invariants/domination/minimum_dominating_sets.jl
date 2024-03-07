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

"""
    compute(::Type{MinimumLocatingDominatingSet}, g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)
    
Return a minimum locating dominating set of `g`.

A subset `W` of the vertices of a graph `g` is a locating dominating set if every vertex
outside of `W` is uniquely determined by its neighborhood in `W`. That is, for every pair
of vertices, `u` and `v`, not in `W`, `N(u) ∩ W ≠ N(v) ∩ W`.

### Implementation Notes
The locating domination set is determined combinatorically (brute force). If you identify a scalable MIP
for this problem, please open an issue on the GitHub repository. Thank you.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute a minimum locating dominating set of.

# Returns

- A minimum locating dominating set of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(3)
{3, 3} undirected simple Int64 graph

julia> compute(MinimumLocatingDominatingSet, g)
MinimumLocatingDominatingSet([1, 2])
```
"""
function compute(
    ::Type{MinimumLocatingDominatingSet},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_size = length(compute(MinimumDominatingSet, g).nodes)
    for size in min_size:Graphs.nv(g)
        for subset in Combinatorics.combinations(1:Graphs.nv(g), size)

            # helper function based on subset
            function locating(x, y)
                return Set(intersect(Graphs.neighbors(g, x), subset)) != Set(intersect(Graphs.neighbors(g, y), subset))
            end

            # check domination
            blue = Set(subset)
            apply!(DominationRule, blue, g)
            if length(blue) != Graphs.nv(g)
                continue
            end

            # gt pairs of nodes that are not in the subset
            node_pairs = []
            for v in 1:Graphs.nv(g)
                if v ∉ subset
                    for u in 1:Graphs.nv(g)
                        if u!= v && u ∉ subset && (u, v) ∉ node_pairs
                            push!(node_pairs, (v, u))
                        end
                    end
                end
            end

            # check if the subset is locating
            is_locating = true
            for (v, u) in node_pairs
                if !locating(v, u)
                    is_locating = false
                    break
                end
            end

            if is_locating
                return MinimumLocatingDominatingSet(subset)
            end
        end
    end
    return MinimumLocatingDominatingSet([]) # this should never happen!
end

"""
    compute(::Type{MinimumPairedDominatingSet}, g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)
    
Return a minimum paired dominating set of `g`. A paired dominating set of a graph `g` is a
subset `S` of the vertices of `g` such that every vertex not in `S` is adjacent to at
least one member of `S` and the members of `S` for a perfect matching; that is, edges can
be selected from the induced subgraph of `g` on `S` such that every vertex in `S` is
incident to exactly one edge in the matching. A minimum paired dominating set is a paired
dominating set of smallest possible cardinality.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the minimum paired dominating set of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the optimization problem.

# Returns

- A `MinimumPairedDominatingSet` object representing the nodes in the minimum paired dominating set of
  `g`. Note: the pairs are not returned.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(8)
{8, 8} undirected simple Int64 graph

julia> compute(MinimumPairedDominatingSet, g)
MinimumPairedDominatingSet([1, 4, 5, 8])
```
"""
function compute(
    ::Type{MinimumPairedDominatingSet},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer

    # if g has a singleton component, then throw an exception
    if any(length(component) == 1 for component in connected_components(g))
        throw(ArgumentError("The graph has a singleton component"))
    end

    # Instantiate the model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    n = Graphs.nv(g)
    m = Graphs.ne(g)

    # mapping from 1 - m to edges
    edge_map = Dict((i, e) for (i, e) in enumerate(Graphs.edges(g)))

    # x[v] = 1 if vertex v is in the paired dominating set
    @variable(model, x[1:n], Bin)

    # y[u, v] = 1 if edge (u, v) is in the paired dominating set (only create variables
    # for edges that exist)
    @variable(model, y[1:m], Bin)
        
    # Objective: min sum(x[v] for v in 1:n)
    @objective(model, Min, sum(x[v] for v in 1:n))

    # Constraint 1:
    for v in 1:n
        neighbors_v = Graphs.neighbors(g, v)
        @constraint(model, x[v] + sum(x[u] for u in neighbors_v) >= 1)
    end

    # Constraint 2:
    for (i, e) in edge_map
        u, v = src(e), dst(e)
        @constraint(model, y[i] ≤ .5 * x[u] + .5 * x[v])
    end

    # Constraint 3:
    for v in 1:n
        # find edges that are incident to v
        incident_edges = [e for e in Graphs.edges(g) if src(e) == v || dst(e) == v]
        
        # get indices of incident edges
        incident_edge_indices = [i for (i, e) in edge_map if e in incident_edges]

        @constraint(model, sum(y[i] for i in incident_edge_indices) == x[v])
    end

    # Solve the model
    optimize!(model)

    # Extract the solution
    paired_dominating_set = [v for v in 1:n if value(x[v]) == 1.0]

    return MinimumPairedDominatingSet(paired_dominating_set)
end

"""
    compute(::Type{MinimumIndependentDominatingSet}, g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer)
    
Return a minimum independent dominating set of `g`.

An independent dominating set of a graph `g` is a subset `S` of the vertices of `g` such
that every vertex not in `S` is adjacent to at least one member of `S` and no two members
of `S` are adjacent. A minimum independent dominating set is an independent dominating set
of smallest possible cardinality.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the minimum independent dominating set of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the optimization problem.

# Returns

- A `MinimumIndependentDominatingSet` object representing the minimum independent
  dominating set of `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> compute(MinimumIndependentDominatingSet, g)
MinimumIndependentDominatingSet([1, 3])
```
"""
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

    # Constraints: ensure that no two vertices in the dominating set are adjacent
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
    compute(::Type{MinimumPowerDominatingSet}, g::SimpleGraph{T})

Return a minimum power dominating set of `g`.

Return the size of a minimum power dominating set of `g`.

A power dominating set of a graph `g` is a subset `S` of the vertices of `g` such that the
closed neighborhood of `S` is a zero forcing set of `g`. See the documentation for zero
forcing for more information.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute a minimum power dominating set of.

# Returns

- The minimum power dominating set of `g`

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = path_graph(10)
{10, 9} undirected simple Int64 graph

julia> compute(MinimumPowerDominatingSet, g)
MinimumPowerDominatingSet([1])
```
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
