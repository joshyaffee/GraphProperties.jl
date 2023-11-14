"""
    compute(::Type{MinimumZeroForcingSet}, g::AbstractGraph)

Return a minimum zero forcing set of `g` using a brute force method.

"""
function compute(
    ::Type{BruteForceMinimumZeroForcingSet},
    g::SimpleGraph{T}
) where T <: Integer

    # Get the number of vertices in `g`.
    n = Graphs.nv(g)

    for size in 1:n
        for subset in Combinatorics.combinations(1:n, size)
            blue = Set(subset)
            apply!(ZeroForcingRule, blue, g; max_iter=n)
            length(blue) == n && return BruteForceMinimumZeroForcingSet(subset)
        end
    end
    error("Could not find a minimum zero forcing set for $g")
end

"""
    compute(::Type{MinimumZeroForcingSet}, g::SimpleGraph)

Return a minimum zero forcing set of the graph `g` using Integer Programming
formulation from Brimkov et al. (2019), published in EJOR:
https://www.sciencedirect.com/science/article/pii/S0377221718308063#sec0007.

# Arguments
- `::Type{MinimumZeroForcingSet}`: The type of zero forcing set to compute.
- `g::SimpleGraph`: The input graph.

# Example
```julia
julia> using Graphs

julia> h = Graphs.complete_graph(4)
{4, 6} undirected simple Int64 graph

julia> compute(MinimumZeroForcingSet, h)
MinimumZeroForcingSet(Set{Int64}([1, 2, 3, 4]))

```
"""

compute(MinimumZeroForcingSet, g)
function compute(
    ::Type{MinimumZeroForcingSet},
    g::SimpleGraph{T}
) where T <: Integer

    # convert to directed graph, replacing each edge with two directed edges
    directed_g = Graphs.DiGraph(g)

    return compute(MinimumZeroForcingSet, directed_g)
end

"""
    compute(::Type{MinimumZeroForcingSet}, g::DiGraph)

Return a minimum zero forcing set of the graph `g` using Integer Programming
formulation from Brimkov et al. (2019), published in EJOR:
https://www.sciencedirect.com/science/article/pii/S0377221718308063#sec0007.

# Arguments
- `::Type{MinimumZeroForcingSet}`: The type of zero forcing set to compute.
- `g::DiGraph`: The input graph.

# Example
```julia
julia> using Graphs

julia> h = Graphs.DiGraph(Graphs.complete_graph(4))
{4, 12} directed simple Int64 graph

julia> compute(MinimumZeroForcingSet, h)
MinimumZeroForcingSet(Set{Int64}([1, 2, 3, 4]))

```
"""
function compute(
    ::Type{MinimumZeroForcingSet},
    g::DiGraph{T},
    optimizer=HiGHS.Optimizer
) where T <: Integer

    # Instantiate the model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    # The number of vertices.
    n = Graphs.nv(g)

    # The number of directed edges.
    m = Graphs.ne(g)

    max_steps = n   # very loose bound for now; should be tightened 
                    # (to diameter of graph?) but I leave it like this for now

    # Binary decision variable for each vertex - is it in Z(G)?
    @variable(model, s[1:n], Bin)

    # Integer decision variable for each vertex - how many steps does it take to force it?
    @variable(model, x[1:n], Int, lower_bound = 0, upper_bound = max_steps)

    # Binary decision variable for each directed edge (u,v) - does u force v?
    @variable(model, y[1:m], Bin)

    # Objective: Minimize the number of vertices in Z(G)
    @objective(model, Min, sum(s[i] for i in 1:n))

    # Constraints: For every vertex, v, it's in the set or exactly on edge is forcing it
    for (v, node) in enumerate(Graphs.vertices(g))
        # find index of all edges that have node as their destination
        # delta_minus = findall(a -> Graphs.dst(a) == node, Graphs.edges(g)) # this is buggy
        delta_minus = []
        for (e, edge) in enumerate(edges(g))
            if Graphs.dst(edge) == node
                push!(delta_minus, e)
            end
        end
        
        # add constraint
        @constraint(model, s[v] + sum(y[e] for e in delta_minus) == 1.0)
    end

    # Constraints: For every directed edge:
        #(u,v), x_u - x_v + (max_steps + 1) * y_uv <= max_steps
    # and
    # For every directed edge, (u,v), For all neighbors of u that are not v, call them w:
        # x_w - x_v + (max_steps + 1) * y_uv <= max_steps
    for (e, edge) in enumerate(edges(g))
        u, v = Graphs.src(edge), Graphs.dst(edge)

        # lambda functions used in case == is ever overridden
        index_u = findfirst(a -> a == u, vertices(g)) 
        index_v = findfirst(a -> a == v, vertices(g))

        # add constraint 1
        @constraint(model, x[index_u] - x[index_v] + (max_steps + 1) * y[e] <= max_steps)

        # find all neighbors of u that are not v
        for w in Graphs.outneighbors(g, u)
            if w != v
                index_w = findfirst(a -> a == w, vertices(g))

                # add constraint 2
                @constraint(model, x[index_w] - x[index_v] + (max_steps + 1) * y[e] <= max_steps)
            end
        end
    end

    # Solve the model.
    optimize!(model)

    # Extract the solution.
    zero_forcing_set = [Graphs.vertices(g)[v] for v in 1:n if value(s[v]) == 1.0]

    return MinimumZeroForcingSet(zero_forcing_set)
end