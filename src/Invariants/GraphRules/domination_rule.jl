function apply!(
    ::Type{DominationRule},
    target_set::Set{T},
    g::SimpleGraph{T},
) where T <: Integer

    for v in copy(target_set)  # use copy to avoid modifying set during iteration
        union!(target_set, Graphs.neighbors(g, v))
    end

    return nothing
end