"""
    size(g::AbstractGraph{T}) where T <: Integer

Return the size (the number of edges) of `g`.

# Arguments
- `g::AbstractGraph{T}`: A graph.

# Returns
- The size of `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.Basics

julia> g = CompleteGraph(5);

julia> size(g)
10
```
"""
function size(g::AbstractGraph{T},) where T <: Integer
    return Graphs.ne(g)
end