"""
    domination_number(g::SimpleGraph; optimizer=HiGHS.Optimizer)})

Return the [domination number](https://en.wikipedia.org/wiki/Dominating_set) of `g`.

A [dominating set](https://en.wikipedia.org/wiki/Dominating_set) of a graph `g` is a
subset `S` of the vertices of `g` such that every vertex in `g` is either in `S` or
adjacent to a vertex in `S`. The domination number of `g` is the cardinality of a
minimum dominating set of `g`.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the domination number of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the minimum dominating
  set problem.

# Returns

- The domination number of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> domination_number(g)
2
```
"""
function domination_number(
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumDominatingSet, g; optimizer=optimizer)
    return length(min_tds.nodes)
end

"""
    total_domination_number(g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)

Return the [total domination number](https://en.wikipedia.org/wiki/Total_dominating_set) of `g`.

A [total dominating set](https://en.wikipedia.org/wiki/Total_dominating_set) of a graph `g` is a
subset `S` of the vertices of `g` such that every vertex in `g` is adjacent to at
least one vertex in `S`. The total domination number of `g` is the cardinality of a
minimum total dominating set of `g`.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the total domination number of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the minimum total dominating
  set problem.

# Returns

- The total domination number of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> total_domination_number(g)
3
```
"""
function total_domination_number(
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumTotalDominatingSet, g; optimizer=optimizer)
    return length(min_tds.nodes)
end

"""
    locating_domination_number(g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)

Return the size of a minimum locating dominating set of `g`.

A subset `W` of the vertices of a graph `g` is a locating dominating set if every vertex
outside of `W` is uniquely determined by its neighborhood in `W`. That is, for every pair
of vertices, `u` and `v`, not in `W`, `N(u) ∩ W ≠ N(v) ∩ W`.

### Implementation Notes
The locating domination set is determined combinatorically (brute force). If you identify a scalable MIP
for this problem, please open an issue on the GitHub repository. Thank you.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the locating domination number of.

# Returns

- The locating domination number of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(3)
{3, 3} undirected simple Int64 graph

julia> locating_domination_number(g)
2
```
"""
function locating_domination_number(
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumLocatingDominatingSet, g, optimizer = optimizer)
    return length(min_tds.nodes)
end

"""
    paired_domination_number(g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)

Return the size of a minimum paired dominating set of `g`.

A subset `W` of the vertices of a graph `g` is a paired dominating set if every vertex in
`g` is either in `W` or adjacent to a vertex in `W` and `W` admits a perfect matching.
That is, there is a set of edges in the induced subgraph of `g` on `W` such that every
vertex in `W` is incident to exactly one edge in the set.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the paired domination number of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the minimum paired dominating
  set problem.

# Returns

- The paired domination number of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(8)
{8, 8} undirected simple Int64 graph

julia> paired_domination_number(g)
4
```
"""
function paired_domination_number(
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumPairedDominatingSet, g; optimizer=optimizer)
    return length(min_tds.nodes)
end

"""
    independent_domination_number(g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)

Return the minimum size of an independent domination set of a graph `g`

An independent domination set of a graph `g` is a subset `S` of the vertices of `g` such
that every vertex in `g` is either in `S` or adjacent to a vertex in `S`, and `S` forms an
independent set in `g`. The independent domination number of `g` is the cardinality of a
minimum independent dominating set of `g`.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the independent domination number of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the minimum independent
  dominating set problem.

# Returns

- The independent domination number of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> independent_domination_number(g)
2
```
"""
function independent_domination_number(
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumIndependentDominatingSet, g; optimizer=optimizer)
    return length(min_tds.nodes)
end

"""
    edge_domination_number(g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)

Return the [edge domination number](https://en.wikipedia.org/wiki/Edge_dominating_set) of `g`.

An [edge dominating set](https://en.wikipedia.org/wiki/Edge_dominating_set) of a graph `g` is a
subset `S` of the edges of `g` such that every edge in `g` is incident to at
least one edge in `S`. The edge domination number of `g` is the cardinality of a
minimum edge dominating set of `g`.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the edge domination number of.

# Returns

- The edge domination number of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> edge_domination_number(g)
2
```
"""
function edge_domination_number(
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumEdgeDominatingSet, g; optimizer=optimizer)
    return length(min_tds.edges)
end

"""
    power_domination_number(g::SimpleGraph{T})

Return the size of a minimum power dominating set of `g`.

A power dominating set of a graph `g` is a subset `S` of the vertices of `g` such that the
closed neighborhood of `S` is a zero forcing set of `g`. See the documentation for zero
forcing for more information.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the power domination number of.

# Returns

- The power domination number of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = path_graph(10)
{10, 9} undirected simple Int64 graph

julia> power_domination_number(g)
1
```
"""
function power_domination_number(
    g::SimpleGraph{T}
) where T <: Integer
    min_pds = compute(MinimumPowerDominatingSet, g)
    return length(min_pds.nodes)
end