"""
    apply!(::Type{ZeroForcingRule}, blue::Set{T}, g::SimpleGraph{T}; max_iter=100_000)

Iteratively applies the zero forcing rule to `g` with the set of blue vertices `blue`.

The zero forcing rule is a rule that is applied to a graph `g` with a set of blue vertices
`blue`. The rule is applied iteratively to the graph by checking each vertex in the graph.
If a vertex is blue and has exactly one white neighbor, then the white neighbor is turned
blue. The rule is applied until no more changes can be made or until `max_iter` iterations 
have been made. 

# Arguments
- `blue::Set{T}`: A set of vertices that are blue.
- `g::SimpleGraph{T}`: A simple graph.
- `max_iter::Int`: The maximum number of iterations to apply the rule.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.GraphRules

julia> g = PathGraph(5);

julia> blue = Set([1, 4]);

julia> apply!(ZeroForcingRule, blue, g)

julia> blue
Set{Int64} with 5 elements:
  5
  4
  2
  3
  1
```
"""
function apply!(
    ::Type{ZeroForcingRule},
    blue::Set{T},
    g::SimpleGraph{T};
    max_iter=100_000 # this limits the number of applications of the rule
) where T <: Integer

    changes_made = true
    iter = 0

    # The set of vertices.
    V = Graphs.vertices(g)

    while changes_made && iter < max_iter
        changes_made = false
        for v in V
            if (v in blue)
                white_neighbors = setdiff(Graphs.neighbors(g, v), blue)
                if length(white_neighbors) == 1
                    union!(blue, white_neighbors)
                    changes_made = true
                end
            end
        end
        iter += 1
    end
end
