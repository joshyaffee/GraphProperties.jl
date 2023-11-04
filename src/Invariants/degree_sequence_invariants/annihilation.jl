
"""
    compute(::Type{AnnihilationNumber}, g::SimpleGraph)

Return the annihilation number of the graph `g`.
"""
function compute(
    ::Type{AnnihilationNumber},
    g::SimpleGraph{T},
) where T <: Integer
    # Sort in non-decreasing order
    D = sort(Graphs.degree(g))

    # The number of edges in `g`.
    m = Graphs.ne(g)

    # The number of vertices in `g`.
    n = Graphs.nv(g)

    for i in reverse(1:n)
        if sum(D[1:i]) <= m
            return i
        end
    end
    return nothing
end