@doc raw"""
    function compute(
        ::Type{MaximumIndependentSet},
        g::AbstractGraph{T};
        optimizer=Cbc.Optimizer,
    ) where T <: Integer

Obtain a [maximum independent set](https://en.wikipedia.org/wiki/Independent_set_(graph_theory)) of `g`.

### Implementation Notes
The independent set is found by solving the following linear program:

```math
\begin{align*}
    \max_{i \in \mathbb{Z}} & \sum\limits_{v \in V} x_v \\
    \;\;\text{s.t.}\; & x_v \in \{0, 1\} & \forall v \in V \\
    & x_u + x_v \leq 1 & \forall uv \in E
\end{align*}
```

# Arguments

- `g::AbstractGraph{T}`: The graph to compute the maximum independent set of.

# Keywords

- `optimizer=Cbc.Optimizer`: The optimizer to use to solve the maximum independent set
  problem.

# Returns

- A `MaximumIndependentSet` object representing the maximum independent set of `g`.

# Example
```jldoctest
julia> using Graphs

julia> g = path_graph(5)
{5, 4} undirected simple Int64 graph

julia> compute(MaximumIndependentSet, g)
MaximumIndependentSet([1, 3, 5])
```
"""
function compute(
    ::Type{MaximumIndependentSet},
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer,
) where T <: Integer

    model = Model(optimizer)  # You can replace Cbc with your preferred optimizer
    JuMP.set_silent(model)  # Suppress solver output

    # The vertex set.
    V = Graphs.vertices(g)

    # The edge set.
    E = Graphs.edges(g)

    # Define binary variables for each vertex
    @variable(model, x[V], Bin)

    # Define the objective function
    @objective(model, Max, sum(x[v] for v in V))

    # Add constraints: adjacent vertices cannot both be in the independent set
    for e in E
        @constraint(model, x[Graphs.src(e)] + x[Graphs.dst(e)] <= 1)
    end

    # Solve the optimization problem
    optimize!(model)

    # Extract the solution
    independent_set = [v for v in V if value(x[v]) == 1.0]

    return MaximumIndependentSet(independent_set)
end
