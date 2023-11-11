module GraphProperties

# Import the Basics module
include(joinpath(@__DIR__, "Basics", "Basics.jl"))
using .Basics


# Import the Graph Rules module
include(joinpath(@__DIR__, "GraphRules", "GraphRules.jl"))
using .GraphRules

# Import the GraphIO module
include(joinpath(@__DIR__, "GraphIO", "GraphIO.jl"))
using .GraphIO

# Import the Degree Sequence Invariants module
include(joinpath(@__DIR__, "DegreeSequenceInvariants", "DegreeSequenceInvariants.jl"))
using .DegreeSequenceInvariants

# Import the Invariants module
include(joinpath(@__DIR__, "Invariants", "Invariants.jl"))
using .Invariants

# Import the Communities module
include(joinpath(@__DIR__, "Communities", "Communities.jl"))
using .Communities

# Import the Draw module
include(joinpath(@__DIR__, "Draw", "Draw.jl"))
using .Draw

export draw

export diameter
export girth
export radius
export size
export order

######################### Export the Primary Types and Apply Function  ##################
export AbstractGraphRule, AbstractDegreeSequenceRule
export DominationRule, HavelHakimiRule, ZeroForcingRule
export apply!

export annihilation_number
export average_degree
export havel_hakimi_residue
export maximum_degree
export minimum_degree
export slater_number
export sub_k_domination_number
export sub_total_k_domination_number

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

#TODO Implement these
# export MinimumLocatingDominatingSet
# export LocatingDominationNumber

# export MinimumPairedDominatingSet
# export PairedDominationNumber

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

export MinimumZeroForcingSet
export ZeroForcingNumber
export zero_forcing_number

export load_edgelist
export write_edgelist!

end
