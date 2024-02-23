"""
    function sub_k_domination_number(
        g::SimpleGraph{T};
        k::Integer = 1,
    ) where T <: Integer

Return the sub-k-domination number of the graph `g`.

The sub-k-domination number of a graph `g` is the smallest integer `t` such that the sum 
of the degrees of the first `t` vertices in the sorted degree sequence with t is at least 
`n`. Scaling by 1/k. Please see the following reference for more information: D. Amos et al., "The 
sub-k-domination number of a graph with applications to k-domination",
arXiv preprint arXiv:1611.02379, (2016)

# Arguments
- `g::SimpleGraph`: A simple graph.
- `k::Integer`: The scaling factor.

# Returns
- The sub-k-domination number of the graph `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.DegreeSequenceInvariants

julia> g = PathGraph(5);

julia> sub_k_domination_number(g, k=1)
2
```
"""
function sub_k_domination_number(
    g::SimpleGraph{T};
    k::Integer = 1,
) where T <: Integer

    # Sort in non-increasing order
    D = sort(degree(g), rev=true)

    # The number of vertices in `g`.
    n = Graphs.nv(g)

    # The sub-k-domination number of `g` is the smallest integer `t` such that
    # the sum of the degrees of the first `t` vertices in the sorted
    # degree sequence with t is at least `n`. Scaling by 1/k
    for i in 1:n
        i + sum(D[1:i]) / k >= n && return i
    end

    return nothing
end

"""
    slater_number(g::SimpleGraph{T},) where T <: Integer

Return the Slater invariant for the graph `g`.

The Slater invariant of a graph `g` is the sub-k-domination number of `g` where `k = 1`.

# Arguments
- `g::SimpleGraph`: A simple graph.

# Returns
- The Slater invariant of the graph `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.DegreeSequenceInvariants

julia> g = PathGraph(5);

julia> slater_number(g)
2
```
"""
function slater_number(g::SimpleGraph{T},) where T <: Integer

    return sub_k_domination_number(g; k=1)
end

"""
    sub_total_k_domination_number(
        g::SimpleGraph{T};
        k::Integer = 1,
    ) where T <: Integer

Return the sub-total domination number of the graph `g`.

The sub-total domination number of a graph `g` is the smallest integer `t` such that the
sum of the degrees of the first `t` vertices in the sorted degree sequence with t is at
least k * n where `n` is the number of vertices in `g` and `k` is just used for scaling 
Please see the following reference for more information: R. Davila, "A note on sub-total 
domination in graphs", arXiv preprint arXiv:1701.07811, (2017)

# Arguments
- `g::SimpleGraph`: A simple graph.
- `k::Integer`: The scaling factor.

# Returns
- The sub-total domination number of the graph `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.DegreeSequenceInvariants

julia> g = CompleteGraph(6);

julia> sub_total_k_domination_number(g, k=1)
2
```
"""
function sub_total_k_domination_number(
    g::SimpleGraph{T};
    k::Integer = 1,
) where T <: Integer

    D = sort(Graphs.degree(g), rev=true)  # Sort in non-increasing order
    n = Graphs.nv(g)

    for i in 1:n
        1/k*sum(D[1:i]) >= n && return i
    end

    return nothing
end
