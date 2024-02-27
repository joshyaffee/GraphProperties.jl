"""
    zero_forcing_number(g::AbstractGraph{T}) where T <: Integer

Return the zero forcing number of `g`.

A set of nodes in a graph `g` is a zero forcing set if it can force all nodes in the graph 
to be colored by the following rules:
    - If a node is colored, it remains colored.
    - If a node is colored and has exactly one uncolored neighbor, that neighbor is
      colored.
A minimum zero forcing set is a zero forcing set of minimum cardinality. The zero forcing
number of `g` is the cardinality of a minimum zero forcing set of `g`.

###Implementation Notes
This method uses an Integer Programming formulation from Brimkov et al. (2019). For a
brute force method, see `compute(BruteForceMinimumZeroForcingSet, g)`.

# Arguments
- `g::AbstractGraph{T}`: The graph to compute the zero forcing number of.

# Returns
- The zero forcing number of `g`.
"""
function zero_forcing_number(
    g::SimpleGraph{T}
) where T <: Integer

    opt_set = compute(MinimumZeroForcingSet, g)
    return length(collect(opt_set.nodes))
end
