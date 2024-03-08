"""
    module Invariants

The `Invariants` module provides functionalities for computing various graph invariants and
optimal sets, such as cliques, colorings, dominations, and matchings. It includes advanced
features for degree sequence invariants and graphical operations based on the rules defined
within the module.

# Exported Types
- `AbstractOptimalNodeSet`: Represents sets of nodes that meet an optimality criterion.
- `AbstractOptimalEdgeSet`: Represents sets of edges that meet an optimality criterion.
- `AbstractOptimalNodeColoring`: Represents an optimal coloring of nodes in a graph.
- `AbstractOptimalEdgeColoring`: Represents an optimal coloring of edges in a graph.
- `AbstractCardinality`: Represents the cardinality of a set.
- `AbstractOptimalCardinality`: Represents the cardinality of an optimal set.
- `AbstractDegreeSequenceInvariant`: Represents an invariant of a graph's degree sequence.

# Exported Functions
- `compute`: Computes the optimal set or invariant of a graph.

# Usage
The module allows for the computation of complex graph invariants and operations through
high-level functions and types. The types are used to represent the results of these
computations, while the functions are used to perform them.

# Examples
```julia
julia> using GraphProperties.Invariants: compute, MaximumIndependentSet

julia> α = compute(MaximumIndependentSet, my_graph)
```
"""
module Invariants

import Base: ==

using Combinatorics
using Graphs
using Graphs.SimpleGraphs: SimpleEdge
using GraphProperties.GraphRules: apply!, DominationRule, ZeroForcingRule
using HiGHS
using JuMP


######################### Define Primary Abstract Types #################################

"""
    AbstractOptimalNodeSet

Represents a set of nodes that meet an optimality criterion.
"""
abstract type AbstractOptimalNodeSet end

"""
    AbstractOptimalEdgeSet

Represents a set of edges that meet an optimality criterion.
"""
abstract type AbstractOptimalEdgeSet end

"""
    AbstractOptimalNodeColoring

Represents an optimal coloring of nodes in a graph.
"""
abstract type AbstractOptimalNodeColoring end

"""
    AbstractOptimalEdgeColoring

Represents an optimal coloring of edges in a graph.
"""
abstract type AbstractOptimalEdgeColoring end

"""
    AbstractCardinality

Represents the cardinality of a set.
"""
abstract type AbstractCardinality end

"""
    AbstractOptimalCardinality

Represents the cardinality of an optimal set.
"""
abstract type AbstractOptimalCardinality end

"""
    AbstractDegreeSequenceInvariant

Represents an invariant of a graph's degree sequence.
"""
abstract type AbstractDegreeSequenceInvariant end

#################### Basic Graph Properties taken from Graphs.jl ##################

"""
    Order

Represents the number of nodes in a graph.
"""
struct Order <: AbstractCardinality end

"""
    Size

Represents the number of edges in a graph.
"""
struct Size <: AbstractCardinality end

"""
    MaximumDegree

Represents the maximum degree of a graph.
"""
struct MaximumDegree <: AbstractDegreeSequenceInvariant end

"""
    MinimumDegree

Represents the minimum degree of a graph.
"""
struct MinimumDegree <: AbstractDegreeSequenceInvariant end

"""
    AverageDegree

Represents the average degree of a graph.
"""
struct AverageDegree <: AbstractDegreeSequenceInvariant end

"""
    Radius

Represents the radius of a graph.
"""
struct Radius <: AbstractCardinality end

"""
    Diameter

Represents the diameter of a graph.
"""
struct Diameter <: AbstractCardinality end

"""
    Girth

Represents the girth of a graph.
"""
struct Girth <: AbstractCardinality end

##################### Graph Optimal Sets and Cardinalities ##############################

"""
    MaximumIndependentSet

Represents a maximum independent set of a graph.
"""
struct MaximumIndependentSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end

"""
    IndependenceNumber

Represents the cardinality of a maximum independent set of a graph.
"""
struct IndependenceNumber <: AbstractOptimalCardinality end

"""
    MaximumClique

Represents a maximum clique of a graph.
"""
struct MaximumClique <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end

"""
    CliqueNumber

Represents the cardinality of a maximum clique of a graph.
"""
struct CliqueNumber <: AbstractOptimalCardinality end

"""
    MinimumProperColoring

Represents a minimum proper coloring of a graph.
"""
struct MinimumProperColoring <: AbstractOptimalNodeColoring
    mapping::Dict{Int, Int}
end

"""
    ChromaticNumber

Represents the number of colors in a minimum proper coloring of a graph.
"""
struct ChromaticNumber <: AbstractOptimalCardinality end

"""
    MinimumDominatingSet

Represents a minimum dominating set of a graph.
"""
struct MinimumDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end

"""
    DominationNumber

Represents the cardinality of a minimum dominating set of a graph.
"""
struct DominationNumber <: AbstractOptimalCardinality end

"""
    MinimumTotalDominatingSet

Represents a minimum total dominating set of a graph.
"""
struct MinimumTotalDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end

"""
    TotalDominationNumber

Represents the cardinality of a minimum total dominating set of a graph.
"""
struct TotalDominationNumber <: AbstractOptimalCardinality end

"""
    MinimumLocatingDominatingSet

Represents a minimum locating dominating set of a graph.
"""
struct MinimumLocatingDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end

"""
    LocatingDominationNumber

Represents the cardinality of a minimum locating dominating set of a graph.
"""
struct LocatingDominationNumber <: AbstractOptimalCardinality end

"""
    MinimumPairedDominatingSet

Represents a minimum paired dominating set of a graph.
"""
struct MinimumPairedDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end

"""
    PairedDominationNumber

Represents the cardinality of a minimum paired dominating set of a graph.
"""
struct PairedDominationNumber <: AbstractOptimalCardinality end

"""
    MinimumIndependentDominatingSet

Represents a minimum independent dominating set of a graph.
"""
struct MinimumIndependentDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end

"""
    IndependentDominationNumber

Represents the cardinality of a minimum independent dominating set of a graph.
"""
struct IndependentDominationNumber <: AbstractOptimalCardinality end

"""
    MinimumEdgeDominatingSet

Represents a minimum edge dominating set of a graph.
"""
struct MinimumEdgeDominatingSet <: AbstractOptimalEdgeSet
    edges::Union{Vector{Tuple{Int, Int}}, Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}}
end

"""
    EdgeDominationNumber

Represents the cardinality of a minimum edge dominating set of a graph.
"""
struct EdgeDominationNumber <: AbstractOptimalCardinality end

"""
    MinimumPowerDominatingSet

Represents a minimum power dominating set of a graph.
"""
struct MinimumPowerDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end

"""
    PowerDominationNumber

Represents the cardinality of a minimum power dominating set of a graph.
"""
struct PowerDominationNumber <: AbstractOptimalCardinality end

"""
    MaximumMatching

Represents a maximum matching of a graph.
"""
struct MaximumMatching <: AbstractOptimalEdgeSet
    edges::Union{Vector{Tuple{Int, Int}}, Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}}
end

"""
    MatchingNumber

Represents the cardinality of a maximum matching of a graph.
"""
struct MatchingNumber <: AbstractOptimalCardinality end

"""
    MinimumZeroForcingSet

Represents a minimum zero forcing set of a graph.
"""
struct MinimumZeroForcingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end

"""
    BruteForceMinimumZeroForcingSet

Represents a minimum zero forcing set of a graph.
Indicates solution was found via brute force
"""

struct BruteForceMinimumZeroForcingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end

"""
    ZeroForcingNumber

Represents the cardinality of a minimum zero forcing set of a graph.
"""
struct ZeroForcingNumber <: AbstractOptimalCardinality end

##################### Graphical Degree Sequence Invariants ##############################

"""
    SlaterNumber

Represents the Slater number of a graph.
"""
struct SlaterNumber <: AbstractDegreeSequenceInvariant end

"""
    HavelHakimiResidue

Represents the Havel-Hakimi residue of a graph.
"""
struct HavelHakimiResidue <: AbstractDegreeSequenceInvariant end

"""
    AnnihilationNumber

Represents the annihilation number of a graph.
"""
struct AnnihilationNumber <: AbstractDegreeSequenceInvariant end

"""
    SubTotalDominationNumber

Represents the sub-total domination number of a graph.
"""
struct SubTotalDominationNumber <: AbstractDegreeSequenceInvariant end

"""
    SubKDominationNumber

Represents the sub-k domination number of a graph.
"""
struct SubKDominationNumber <: AbstractDegreeSequenceInvariant
    k::Int
end
SubKDominationNumber(;k=1) = SubKDominationNumber(k)



#############################################################################################

# Include files from src.

# include(joinpath(@__DIR__, "basics", "from_graphs.jl", ))

include(joinpath(@__DIR__, "cliques", "maximimum_clique.jl", ))
include(joinpath(@__DIR__, "cliques", "clique_number.jl", ))

include(joinpath(@__DIR__, "chromatic_colorings", "proper_colorings.jl", ))
include(joinpath(@__DIR__, "chromatic_colorings", "chromatic_number.jl", ))

# include(joinpath(@__DIR__, "degree_sequence_invariants", "havel_hakimi_residue.jl", ))
# include(joinpath(@__DIR__, "degree_sequence_invariants", "slater.jl", ))
# include(joinpath(@__DIR__, "degree_sequence_invariants", "annihilation.jl", ))

include(joinpath(@__DIR__, "domination", "minimum_dominating_sets.jl", ))
include(joinpath(@__DIR__, "domination", "domination_numbers.jl", ))

include(joinpath(@__DIR__, "independence", "max_independent_set.jl", ))
include(joinpath(@__DIR__, "independence", "independence_number.jl", ))

include(joinpath(@__DIR__, "matching", "matching_sets.jl", ))
include(joinpath(@__DIR__, "matching", "matching_number.jl", ))

include(joinpath(@__DIR__, "zero_forcing", "minimum_zero_forcing_set.jl", ))
include(joinpath(@__DIR__, "zero_forcing", "zero_forcing_number.jl", ))

include(joinpath(@__DIR__, "equality.jl", ))

# Exports
export AbstractOptimalNodeSet
export AbstractOptimalEdgeSet
export AbstractOptimalNodeColoring
export AbstractOptimalEdgeColoring

export MaximumIndependentSet
export IndependenceNumber
export independence_number

export MaximumClique
export CliqueNumber
export clique_number

export MinimumProperColoring
export ChromaticNumber
export chromatic_number

export MinimumDominatingSet
export DominationNumber
export domination_number

export MinimumTotalDominatingSet
export TotalDominationNumber
export total_domination_number

export locating_domination_number
export MinimumLocatingDominatingSet

export paired_domination_number
export MinimumPairedDominatingSet

export MinimumPowerDominatingSet
export PowerDominationNumber
export power_domination_number

export MinimumIndependentDominatingSet
export IndependentDominationNumber
export independent_domination_number

export MinimumEdgeDominatingSet
export EdgeDominationNumber
export edge_domination_number

export MaximumMatching
export MatchingNumber
export matching_number

export BruteForceMinimumZeroForcingSet
export MinimumZeroForcingSet
export ZeroForcingNumber
export zero_forcing_number

export compute

end