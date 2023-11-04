"""
    compute(::Type{MinimumZeroForcingSet}, g::AbstractGraph)

Return a minimum zero forcing set of `g`.

"""
function compute(
    ::Type{MinimumZeroForcingSet},
    g::SimpleGraph{T}
) where T <: Integer

    # Get the number of vertices in `g`.
    n = Graphs.nv(g)

    for size in 1:n
        for subset in Combinatorics.combinations(1:n, size)
            blue = Set(subset)
            apply!(ZeroForcingRule, blue, g; max_iter=n)
            if length(blue) == n
                return MinimumZeroForcingSet(subset)
            end
        end
    end
    return []
end
