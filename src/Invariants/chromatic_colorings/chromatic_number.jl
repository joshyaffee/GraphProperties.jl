
"""
    chromatic_number(
        g::AbstractGraph{T}
    ) where T <: Integer

Return the chromatic number of `g`.

"""
function chromatic_number(
    g::SimpleGraph{T};
    optimizer = HiGHS.Optimizer
) where T <: Integer
    min_prop_coloring = compute(MinimumProperColoring, g; optimizer=optimizer)
    return length(unique(values(min_prop_coloring.mapping)))
end
