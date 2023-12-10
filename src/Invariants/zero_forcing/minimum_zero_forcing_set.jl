"""
    compute(::Type{BruteForceMinimumZeroForcingSet}, g::AbstractGraph)

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
function compute(
    ::Type{MinimumZeroForcingSet},
    g::SimpleGraph{T};
    optimizer= HiGHS.Optimizer
) where T <: Integer

    # convert to directed graph, replacing each edge with two directed edges
    directed_g = Graphs.DiGraph(g)

    return compute(MinimumZeroForcingSet, directed_g, optimizer)
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
    optimizer= HiGHS.Optimizer
) where T <: Integer

    # Instantiate the model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    node_array = collect(Graphs.vertices(g))
    edge_array = [(e.src, e.dst) for e in collect(Graphs.edges(g))]

    max_steps = length(node_array) - 1 # very loose bound for now; should be tightened 

    # Binary decision variable for each vertex - is it in Z(G)?
    @variable(model, s[1:length(node_array)], Bin)

    # Integer decision variable for each vertex - how many steps does it take to force it?
    @variable(model, x[1:length(node_array)], Int, lower_bound = 0, upper_bound = max_steps)

    # Binary decision variable for each directed edge (u,v) - does u force v?
    @variable(model, y[edge_array], Bin)

    # Objective: Minimize the number of vertices in Z(G)
    @objective(model, Min, sum(s))

    # Constraints: For every vertex, v, it's in the set or exactly on edge is forcing it
    for node in node_array
        # find index of all edges that have node as their destination
        # delta_minus = findall(a -> Graphs.dst(a) == node, Graphs.edges(g)) # this is buggy
        delta_minus = []
        for edge in edge_array
            if edge[2] == node
                push!(delta_minus, edge)
            end
        end
        
        # add constraint
        @constraint(model, s[node] + sum(y[edge] for edge in delta_minus) == 1.0)
    end

    # Constraints: For every directed edge:
        #(u,v), x_u - x_v + (max_steps + 1) * y_uv <= max_steps
    # and
    # For every directed edge, (u,v), For all neighbors of u that are not v, call them w:
        # x_w - x_v + (max_steps + 1) * y_uv <= max_steps
    for edge in edge_array
        u, v = edge[1], edge[2]

        # add constraint 1
        @constraint(model, x[u] - x[v] + (max_steps + 1) * y[edge] <= max_steps)

        # find all neighbors of u that are not v
        for w in Graphs.inneighbors(g, u)
            if w != v

                # add constraint 2
                @constraint(model, x[w] - x[v] + (max_steps + 1) * y[edge] <= max_steps)
            end
        end
    end

    # Solve the model.
    optimize!(model)

    # Extract the solution.
    zero_forcing_set = [v for v in node_array if value(s[v]) == 1.0]

    return MinimumZeroForcingSet(zero_forcing_set)
end

# function compute(
#     ::Type{MinimumZeroForcingSet},
#     g::DiGraph{T},
#     optimizer= HiGHS.Optimizer
# ) where T <: Integer

#     # Instantiate the model.
#     model = Model(optimizer)
#     JuMP.set_silent(model)

#     # The number of vertices.
#     n = Graphs.nv(g)

#     # The number of directed edges.
#     m = Graphs.ne(g)

#     max_steps = n   # very loose bound for now; should be tightened 
#                     # (to diameter of graph?) but I leave it like this for now
    
#     node_array = collect(Graphs.vertices(g))
#     edge_array = collect(Graphs.edges(g))

#     # Binary decision variable for each vertex - is it in Z(G)?
#     @variable(model, s[1:n], Bin)

#     # Integer decision variable for each vertex - how many steps does it take to force it?
#     @variable(model, x[1:n], Int, lower_bound = 0, upper_bound = max_steps)

#     # Binary decision variable for each directed edge (u,v) - does u force v?
#     @variable(model, y[1:m], Bin)

#     # Objective: Minimize the number of vertices in Z(G)
#     @objective(model, Min, sum(s[i] for i in 1:n))

#     # Constraints: For every vertex, v, it's in the set or exactly on edge is forcing it
#     for (v, node) in enumerate(node_array)
#         # find index of all edges that have node as their destination
#         # delta_minus = findall(a -> Graphs.dst(a) == node, Graphs.edges(g)) # this is buggy
#         delta_minus = []
#         for (e, edge) in enumerate(edge_array)
#             if Graphs.dst(edge) == node
#                 push!(delta_minus, e)
#             end
#         end
        
#         # add constraint
#         @constraint(model, s[v] + sum(y[e] for e in delta_minus) == 1.0)
#     end

#     # Constraints: For every directed edge:
#         #(u,v), x_u - x_v + (max_steps + 1) * y_uv <= max_steps
#     # and
#     # For every directed edge, (u,v), For all neighbors of u that are not v, call them w:
#         # x_w - x_v + (max_steps + 1) * y_uv <= max_steps
#     for (e, edge) in enumerate(edge_array)
#         u, v = Graphs.src(edge), Graphs.dst(edge)

#         # lambda functions used in case == is ever overridden
#         index_u = findfirst(a -> a == u, node_array) 
#         index_v = findfirst(a -> a == v, node_array)

#         # add constraint 1
#         @constraint(model, x[index_u] - x[index_v] + (max_steps + 1) * y[e] <= max_steps)

#         # find all neighbors of u that are not v
#         for w in Graphs.inneighbors(g, u)
#             if w != v
#                 index_w = findfirst(a -> a == w, node_array)

#                 # add constraint 2
#                 @constraint(model, x[index_w] - x[index_v] + (max_steps + 1) * y[e] <= max_steps)
#             end
#         end
#     end

#     # Solve the model.
#     optimize!(model)

#     # Extract the solution.
#     zero_forcing_set = [node_array[v] for v in 1:n if value(s[v]) == 1.0]

#     return MinimumZeroForcingSet(zero_forcing_set)
# end

#######################