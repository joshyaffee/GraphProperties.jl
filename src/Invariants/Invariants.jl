module Invariants

using Combinatorics
using Graphs
using HiGHS
using JuMP
using Colors
using GraphPlot


# Include the graph operation rules module.
include("GraphRules/GraphRules.jl")
using .GraphRules

######################### Define Primary Abstract Types #################################
abstract type AbstractOptimalNodeSet end
abstract type AbstractOptimalEdgeSet end

abstract type AbstractOptimalNodeColoring end
abstract type AbstractOptimalEdgeColoring end

abstract type AbstractCardinality end
abstract type AbstractOptimalCardinality end

abstract type AbstractDegreeSequenceInvariant end

#################### Basic Graph Properties taken from Graphs.jl ##################

struct Order <: AbstractCardinality end
struct Size <: AbstractCardinality end

struct MaximumDegree <: AbstractDegreeSequenceInvariant end
struct MinimumDegree <: AbstractDegreeSequenceInvariant end
struct AverageDegree <: AbstractDegreeSequenceInvariant end

struct Radius <: AbstractCardinality end
struct Diameter <: AbstractCardinality end
struct Girth <: AbstractCardinality end

##################### Graph Optimal Sets and Cardinalities ##############################

struct MaximumIndependentSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end
struct IndependenceNumber <: AbstractOptimalCardinality end

struct MaximumClique <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end
struct CliqueNumber <: AbstractOptimalCardinality end

struct MinimumProperColoring <: AbstractOptimalNodeColoring
    mapping::Dict{Int, Int}
end
struct ChromaticNumber <: AbstractOptimalCardinality end

struct MinimumDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end
struct DominationNumber <: AbstractOptimalCardinality end

struct MinimumTotalDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end
struct TotalDominationNumber <: AbstractOptimalCardinality end

struct MinimumLocatingDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end
struct LocatingDominationNumber <: AbstractOptimalCardinality end

struct MinimumPairedDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end
struct PairedDominationNumber <: AbstractOptimalCardinality end

struct MinimumIndependentDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end
struct IndependentDominationNumber <: AbstractOptimalCardinality end

struct MinimumEdgeDominatingSet <: AbstractOptimalEdgeSet
    edges::Union{Vector{Tuple{Int, Int}}, Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}}
end
struct EdgeDominationNumber <: AbstractOptimalCardinality end

struct MinimumPowerDominatingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end
struct PowerDominationNumber <: AbstractOptimalCardinality end

struct MaximumMatching <: AbstractOptimalEdgeSet
    edges::Union{Vector{Tuple{Int, Int}}, Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}}
end
struct MatchingNumber <: AbstractOptimalCardinality end

struct MinimumZeroForcingSet <: AbstractOptimalNodeSet
    nodes::Vector{Int}
end
struct ZeroForcingNumber <: AbstractOptimalCardinality end

##################### Graphical Degree Sequence Invariants ##############################

struct SlaterNumber <: AbstractDegreeSequenceInvariant end
struct HavelHakimiResidue <: AbstractDegreeSequenceInvariant end
struct AnnihilationNumber <: AbstractDegreeSequenceInvariant end
struct SubTotalDominationNumber <: AbstractDegreeSequenceInvariant end
struct SubKDominationNumber <: AbstractDegreeSequenceInvariant
    k::Int
end
SubKDominationNumber(;k=1) = SubKDominationNumber(k)

##################### Graphical Degree Sequence Operations ##############################



#############################################################################################

# Include files from src.

include("basics/from_graphs.jl")

include("cliques/maximimum_clique.jl")
include("cliques/clique_number.jl")

include("chromatic_colorings/proper_colorings.jl")
include("chromatic_colorings/chromatic_number.jl")

include("degree_sequence_invariants/havel_hakimi_residue.jl")
include("degree_sequence_invariants/slater.jl")
include("degree_sequence_invariants/annihilation.jl")

include("domination/minimum_dominating_sets.jl")
include("domination/domination_numbers.jl")

include("independence/independence_number.jl")
include("independence/max_independent_set.jl")

include("matching/matching_sets.jl")
include("matching/matching_number.jl")

include("zero_forcing/minimum_zero_forcing_set.jl")
include("zero_forcing/zero_forcing_number.jl")

include("drawing/draw-optimal-sets.jl")

# Exports
export AbstractOptimalNodeSet
export AbstractOptimalEdgeSet
export AbstractOptimalNodeColoring
export AbstractOptimalEdgeColoring
export AbstractOptimalCardinality
export DegreeSequenceInvariant
export GraphRule

export Order
export Size
export Girth

export MaximumDegree
export MinimumDegree
export AverageDegree

export Radius
export Diameter

export MaximumIndependentSet
export IndependenceNumber

export MaximumClique
export CliqueNumber

export MinimumProperColoring
export ChromaticNumber

export MinimumDominatingSet
export DominationNumber
export DominationRule

export MinimumTotalDominatingSet
export TotalDominationNumber

export MinimumLocatingDominatingSet
export LocatingDominationNumber

export MinimumPairedDominatingSet
export PairedDominationNumber

export MinimumPowerDominatingSet
export PowerDominationNumber

export MinimumIndependentDominatingSet
export IndependentDominationNumber

export MinimumEdgeDominatingSet
export EdgeDominationNumber

export MaximumMatching
export MatchingNumber

export MinimumZeroForcingSet
export ZeroForcingNumber
export ZeroForcingRule

export HavelHakimiRule
export HavelHakimiResidue
export SlaterNumber
export AnnihilationNumber
export SubTotalDominationNumber
export SubKDominationNumber

export apply!
export compute
export draw_optimal_set


end