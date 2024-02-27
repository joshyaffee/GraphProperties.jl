
"""
    radius(g::AbstractGraph{T}) where T <: Integer

Return the radius of `g`.

The radius of a graph is the minimum eccentricity of its vertices. In other words, it is 
the minimum distance from any vertex to the farthest vertex from it.

# Arguments
- `g::AbstractGraph{T}`: A graph.

# Returns
- The radius of `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.Basics

julia> g = PathGraph(5);

julia> radius(g)
2
```
"""
function radius(g::SimpleGraph{T}) where T <: Integer
    return Graphs.radius(g)
end
