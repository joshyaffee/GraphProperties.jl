"""
    compute(::Type{DominationNumber}, g::SimpleGraph; optimizer=HiGHS.Optimizer)})

Return the [domination number](https://en.wikipedia.org/wiki/Dominating_set) of `g`.

### Description

A [dominating set](https://en.wikipedia.org/wiki/Dominating_set) of a graph `g` is a
subset `S` of the vertices of `g` such that every vertex in `g` is either in `S` or
adjacent to a vertex in `S`. The domination number of `g` is the cardinality of a
minimum dominating set of `g`.

## Example

```jldoctest
julia> using Graphs

julia> using GraphInvariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> compute(DominationNumber, g)
2
```
"""
function compute(
    ::Type{DominationNumber},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumDominatingSet, g; optimizer=optimizer)
    return length(min_tds.nodes)
end

"""
    compute(::Type{TotalDominationNumber}, g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)

Return the [total domination number](https://en.wikipedia.org/wiki/Total_dominating_set) of `g`.

### Description
A [total dominating set](https://en.wikipedia.org/wiki/Total_dominating_set) of a graph `g` is a
subset `S` of the vertices of `g` such that every vertex in `g` is adjacent to at
least one vertex in `S`. The total domination number of `g` is the cardinality of a
minimum total dominating set of `g`.

## Example

```jldoctest
julia> using Graphs

julia> using GraphInvariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> compute(TotalDominationNumber, g)
3
```
"""
function compute(
    ::Type{TotalDominationNumber},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumTotalDominatingSet, g; optimizer=optimizer)
    return length(min_tds.nodes)
end


function compute(
    ::Type{LocatingDominationNumber},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumLocatingDominatingSet, g; optimizer=optimizer)
    return length(min_tds.nodes)
end


function compute(
    ::Type{PairedDominationNumber},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumPairedDominatingSet, g; optimizer=optimizer)
    return length(min_tds.nodes)
end

"""
    compute(::Type{IndependentDominationNumber}, g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)

Return the [independent domination number](https://en.wikipedia.org/wiki/Independent_dominating_set) of `g`.

### Description
An [independent dominating set](https://en.wikipedia.org/wiki/Independent_dominating_set) of a graph `g` is a
subset `S` of the vertices of `g` such that every vertex in `g` is either in `S` or
adjacent to a vertex in `S`, and `S` forms an independent set in `g`. The independent domination number of `g`
is the cardinality of a minimum independent dominating set of `g`.

## Example

```jldoctest
julia> using Graphs

julia> using GraphInvariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> compute(IndependentDominationNumber, g)
2
```
"""
function compute(
    ::Type{IndependentDominationNumber},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumIndependentDominatingSet, g; optimizer=optimizer)
    return length(min_tds.nodes)
end

"""
    compute(::Type{EdgeDominationNumber}, g::SimpleGraph{T}; optimizer=HiGHS.Optimizer)

Return the [edge domination number](https://en.wikipedia.org/wiki/Edge_dominating_set) of `g`.

### Description
An [edge dominating set](https://en.wikipedia.org/wiki/Edge_dominating_set) of a graph `g` is a
subset `S` of the edges of `g` such that every edge in `g` is incident to at
least one edge in `S`. The edge domination number of `g` is the cardinality of a
minimum edge dominating set of `g`.

## Example

```jldoctest
julia> using Graphs

julia> using GraphInvariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> compute(EdgeDominationNumber, g)
2
```
"""
function compute(
    ::Type{EdgeDominationNumber},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer
    min_tds = compute(MinimumEdgeDominatingSet, g; optimizer=optimizer)
    return length(min_tds.edges)
end

"""
    compute(::Type{PowerDominationNumber}, g::SimpleGraph{T})

Return the [power domination number](https://en.wikipedia.org/wiki/Power_dominating_set) of `g`.

"""
function compute(
    ::Type{PowerDominationNumber},
    g::SimpleGraph{T}
) where T <: Integer
    min_pds = compute(MinimumPowerDominatingSet, g)
    return length(min_pds.nodes)
end
