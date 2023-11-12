"""
    zero_forcing_number(g::AbstractGraph{T}) where T <: Integer

Return the zero forcing number of `g`.

"""
function zero_forcing_number(
    g::SimpleGraph{T}
) where T <: Integer

    opt_set = compute(MinimumZeroForcingSet, g)
    return length(collect(opt_set.nodes))
end
