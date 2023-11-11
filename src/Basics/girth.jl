
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