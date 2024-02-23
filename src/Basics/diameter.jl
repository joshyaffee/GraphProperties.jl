"""
    diameter(g::AbstractGraph{T}) where T <: Integer

Return the diameter of `g`.

# Arguments
- `g::AbstractGraph{T}`: A graph.

# Returns
- The diameter of `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.Basics

julia> g = PathGraph(5);

julia> diameter(g)
4
```
"""
function diameter(g::SimpleGraph{T}) where T <: Integer
    return Graphs.diameter(g)
end
