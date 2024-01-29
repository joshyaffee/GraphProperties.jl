"""
    compute(::Type{BruteForceMinimumZeroForcingSet}, g::AbstractGraph)

Return a minimum zero forcing set of `g` using a brute force method. 

This method assures correctness, but is not efficient for large graphs. A set of nodes is
considered zero forcing if it can force all nodes in the graph to be colored by the
following rules:
    - If a node is colored, it remains colored.
    - If a node is colored and has exactly one uncolored neighbor, that neighbor is
      colored.
A minimum zero forcing set is a zero forcing set of minimum cardinality.

# Arguments
- g::AbstractGraph: The input graph.

# Examples
```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = path_graph(5)
{5, 4} undirected simple Int64 graph

julia> compute(BruteForceMinimumZeroForcingSet, g)
BruteForceMinimumZeroForcingSet(Set{Int64}([1]))

julia> h = Graphs.complete_graph(4)
{4, 6} undirected simple Int64 graph

julia> compute(BruteForceMinimumZeroForcingSet, h)
BruteForceMinimumZeroForcingSet(Set{Int64}([1, 2, 3]))
```
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

Return a minimum zero forcing set of the graph `g` 

This method uses an Integer Programming formulation from Brimkov et al. (2019), published
in [EJOR](https://www.sciencedirect.com/science/article/pii/S0377221718308063#sec0007).

### Implementation Notes
This method converts the input graph to a directed graph, replacing each edge with two
directed edges. If the input graph is already directed, a different method is used. This
method uses the HiGHS optimizer to solve the Integer Program by deafault and has
encountered some issues with this optimizer. If you encounter issues, try using a
different optimizer.

# Arguments
- `g::SimpleGraph`: The input graph.

# Keywords
- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the minimum zero forcing
  set problem.

# Example
```julia
julia> using Graphs

julia> h = Graphs.complete_graph(4)
{4, 6} undirected simple Int64 graph

julia> compute(MinimumZeroForcingSet, h)
MinimumZeroForcingSet(Set{Int64}([1, 2, 3]))
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
    compute(::Type{MinimumZeroForcingSet}, g::SimpleGraph)

Return a minimum zero forcing set of the graph `g` 

This method uses an Integer Programming formulation from Brimkov et al. (2019), published
in [EJOR](https://www.sciencedirect.com/science/article/pii/S0377221718308063#sec0007).

### Implementation Notes
This method uses the HiGHS optimizer to solve the Integer Program by deafault and has
encountered some issues with this optimizer. If you encounter issues, try using a
different optimizer.

# Arguments
- `g::DiGraph{T}`: The input graph, with directed edges.

# Keywords
- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the minimum zero forcing
  set problem.

# Example
```julia
julia> using Graphs

julia> h = Graphs.complete_graph(4)
{4, 6} undirected simple Int64 graph

julia> directed_h = Graphs.DiGraph(h)
{4, 12} directed simple Int64 graph

julia> compute(MinimumZeroForcingSet, directed_h)
MinimumZeroForcingSet(Set{Int64}([1, 2, 3]))
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