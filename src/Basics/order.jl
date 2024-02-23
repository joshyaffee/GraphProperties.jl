"""
    order(g::AbstractGraph{T}) where T <: Integer

Return the order (the number of vertices) of `g`.

# Arguments
- `g::AbstractGraph{T}`: A graph.

# Returns
- The order of `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.Basics

julia> g = PathGraph(5);

julia> order(g)
5
```
"""
function order(g::AbstractGraph{T},) where T <: Integer
    return Graphs.nv(g)
end