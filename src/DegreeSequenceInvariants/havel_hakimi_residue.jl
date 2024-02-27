"""
    havel_hakimi_residue(g::SimpleGraph)

Return the Havel-Hakimi residue of the graph `g`.

The Havel-Hakimi residue of a graph `g` is the length of the degree sequence after
applying the Havel-Hakimi rule to the degree sequence of `g`. This method returns the
length of the final sequence after applying the Havel-Hakimi rule as long as it may be
applied.

# Arguments
- `g::SimpleGraph`: A simple graph.

# Returns
- The Havel-Hakimi residue of the graph `g`.

# Example
```jldoctest
julia> using Graphs

julia> using GraphProperties.DegreeSequenceInvariants

julia> g = PathGraph(5);

julia> havel_hakimi_residue(g)
2
```
"""
function havel_hakimi_residue(g::SimpleGraph{T},) where T <: Integer

    # Get the degree sequence of `g`.
    sequence = Graphs.degree(g)

    # Sort the degree sequence in descending order.
    sort!(sequence, rev=true)

    # Apply the Havel-Hakimi rule to the degree sequence until
    # the sequene only contains zeros.
    while apply!(HavelHakimiRule, sequence) end

    # Return the length of the sequence.
    return length(sequence)
end
