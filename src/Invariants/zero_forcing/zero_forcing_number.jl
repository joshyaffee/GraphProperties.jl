"""
    compute(::Type{ZeroForcingNumber}, g::AbstractGraph{T}) where T <: Integer

Return the zero forcing number of `g`.

"""
function compute(
    ::Type{ZeroForcingNumber},
    g::SimpleGraph{T}
) where T <: Integer
    opt_set = compute(MinimumZeroForcingSet, g)
    return length(opt_set.nodes)
end
