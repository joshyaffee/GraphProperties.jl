module GraphRules

using Graphs

######################### Define Primary Abstract Types #################################
"""
    AbstractGraphRule

An abstract type that represents a rule that is applied to a graph.
"""
abstract type AbstractGraphRule end

"""
    AbstractDegreeSequenceRule

An abstract type that represents a rule that is applied to a degree sequence.
"""
abstract type AbstractDegreeSequenceRule end

############################ Graph Operations as Rules ##################################

"""
    DominationRule

A rule that is applied to a graph to determine if vertices set `S` is a dominating set.
"""
struct DominationRule <: AbstractGraphRule end

"""
    ZeroForcingRule

A rule to determine if vertices set `blue` is a zero forcing set of `g`.
"""
struct ZeroForcingRule <: AbstractGraphRule end

##################### Graphical Degree Sequence Operations ##############################

"""
    HavelHakimiRule

A rule that is applied to a degree sequence iteratively to determine if it is graphical.
"""
struct HavelHakimiRule <: AbstractDegreeSequenceRule end


######################### Include the Primary Functions #################################
include("domination_rule.jl")
include("zero_forcing_rule.jl")
include("havel_hakimi.jl")

######################### Export the Primary Types and Apply Function  ##################
export AbstractGraphRule, AbstractDegreeSequenceRule
export DominationRule, HavelHakimiRule, ZeroForcingRule
export apply!

end