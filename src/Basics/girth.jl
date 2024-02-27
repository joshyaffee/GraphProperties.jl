"""
    girth(g::SimpleGraph{T}) where T <: Integer

Return the girth of `g`.

The girth of a graph is the length of the shortest cycle in the graph.

# Arguments
- `g::SimpleGraph{T}`: A graph.

# Returns
- The girth of `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.Basics

julia> g = PathGraph(5);

julia> girth(g)
Inf
```
"""
function girth(g::SimpleGraph{T},) where T <: Integer

    shortest_cycle = Inf

    for v in vertices(g)
        dist = fill(Inf, nv(g))
        parent = zeros(Int, nv(g))
        dist[v] = 0
        q = [v]

        while !isempty(q)
            current = popfirst!(q)
            for neighbor in neighbors(g, current)
                if dist[neighbor] == Inf
                    push!(q, neighbor)
                    dist[neighbor] = dist[current] + 1
                    parent[neighbor] = current
                elseif parent[current] != neighbor
                    # We've found a cycle
                    cycle_length = dist[current] + dist[neighbor] + 1
                    shortest_cycle = min(shortest_cycle, cycle_length)
                end
            end
        end
    end

    return isinf(shortest_cycle) ? 0 : shortest_cycle
end