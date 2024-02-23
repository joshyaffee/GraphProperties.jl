"""
    is_triangle_free(G::SimpleGraph{T})

Return `true` if `G` is triangle-free, and `false` otherwise.

A graph is triangle-free if it does not contain any induced subgraph isomorphic to a
triangle.

# Arguments
- `G::SimpleGraph{T}`: A graph.

# Returns
- `true` if `G` is triangle-free, and `false` otherwise.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.Basics

julia> g = PathGraph(5);

julia> is_triangle_free(g)
true
```
"""
function is_triangle_free(G::SimpleGraph{T}) where T <: Integer

    # iterate over edges
    for e in Graphs.edges(G)

        # extract incident nodes
        e isa Graphs.SimpleEdge && ((u, v) = (e.src, e.dst))
        e isa Tuple && (u, v = e)

        # if the nodes share a neighbor, return false
        for w in Graphs.neighbors(G, u)
            w != v && Graphs.has_edge(G, w, v) && return false
        end
    end

    # if no triangles found, return true
    return true
end

"""
    is_bull_free(G::SimpleGraph{T})

Return `true` if no induced subgraph of `G` is a bull, and `false` otherwise.

A bull is a graph formed by adding two pendant edges to separate verticies of a triangle.

# Arguments
- `G::SimpleGraph{T}`: A graph.

# Returns
- `true` if `G` is bull-free, and `false` otherwise.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.Basics

julia> g = Graphs.SimpleGraph(5);

julia> add_edge!(g, 1, 2);

julia> add_edge!(g, 2, 3);

julia> add_edge!(g, 3, 1);

julia> add_edge!(g, 2, 4);

julia> add_edge!(g, 2, 5);

julia> is_bull_free(g)
true
```
"""
function is_bull_free(G::SimpleGraph{T}) where T <: Integer

    # iterate over edges
    for e in Graphs.edges(G)

        # extract incident nodes
        e isa Graphs.SimpleEdge && ((u, v) = (e.src, e.dst))
        e isa Tuple && (u, v = e)

        # if the nodes share a neighbor, examine triangle for bullhorns
        for w in Graphs.neighbors(G, u)
            if w != v && Graphs.has_edge(G, w, v)

                # check if u and v have disjoint edges, and that the subgraph is induced
                for x in Graphs.neighbors(G,u)
                    if !Graphs.has_edge(G, x, v) && !Graphs.has_edge(G, x, w)
                        for y in Graphs.neighbors(G,v)
                            Graphs.has_edge(G, y, u) || Graphs.has_edge(G, y, w) || \
                            Graphs.has_edge(G, y, x) || return false
                        end
                    end
                end
            end
        end
    end

    return true
end

"""
    is_claw_free(G::SimpleGraph{T})

Return `true` if no induced subgraph of `G` is a claw, and `false` otherwise.

A claw is a graph formed by adding three pendant edges to a single vertex.

# Arguments
- `G::SimpleGraph{T}`: A graph.

# Returns
- `true` if `G` is claw-free, and `false` otherwise.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.Basics

julia> g = Graphs.SimpleGraph(5);

julia> add_edge!(g, 1, 2);

julia> add_edge!(g, 1, 3);

julia> add_edge!(g, 1, 4);

julia> add_edge!(g, 1, 5);

julia> is_claw_free(g)
false
```
"""
function is_claw_free(G::SimpleGraph{T}) where T <: Integer

    # iterate over possible center of the stars
    for v in Graphs.vertices(G)
        Graphs.degree(G, v) >= 3 || continue

        # find neighbors v, w, and x of v and check for claw
        v_neighbors = Set(Graphs.neighbors(G, v))
        for u in Graphs.neighbors(G, v)
            for w in v_neighbors
                if u != w && !Graphs.has_edge(G, u, w)
                    for x in v_neighbors
                        x == u || x == w || Graphs.has_edge(G, u, x) || \ 
                        Graphs.has_edge(G, w, x) || return false
                    end
                end
            end

            # if no claws were foudn with u, don't check it again
            delete!(v_neighbors, u)
        end
    end

    return true
end