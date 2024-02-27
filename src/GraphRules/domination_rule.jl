"""
    apply!(::Type{DominationRule}, target_set::Set{T}, g::SimpleGraph{T}) where T <: Integer
    
Apply the domination rule to the target set of vertices in the graph `g`.

The domination rule states that if a vertex `v` is in the target set, then on the next
iteration (after applying the rule) all of the neighbors of `v` will be in the target set.
The method modifies the target set in place.

# Arguments
- `target_set::Set{T}`: The set of vertices to which the rule is applied.
- `g::SimpleGraph{T}`: The graph to which the rule is applied.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.GraphRules

julia> g = path_graph(5)
{5, 4} undirected simple Int64 graph

julia> target_set = Set([1]);

julia> apply!(DominationRule, target_set, g)

julia> target_set
Set([1, 2])

julia> apply!(DominationRule, target_set, g)

julia> target_set
Set([1, 2, 3])
```
"""
function apply!(
    ::Type{DominationRule},
    target_set::Set{T},
    g::SimpleGraph{T},
) where T <: Integer

    for v in copy(target_set)  # use copy to avoid modifying set during iteration
        union!(target_set, Graphs.neighbors(g, v))
    end

    return nothing
end
