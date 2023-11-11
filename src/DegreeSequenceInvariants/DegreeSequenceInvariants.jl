module DegreeSequenceInvariants

using Graphs
using GraphProperties.GraphRules: apply!, HavelHakimiRule
using Statistics

include(joinpath(@__DIR__, "annihilation.jl"))
include(joinpath(@__DIR__, "havel_hakimi_residue.jl"))
include(joinpath(@__DIR__, "slater.jl"))
include(joinpath(@__DIR__, "degree.jl"))

export annihilation_number
export average_degree
export havel_hakimi_residue
export maximum_degree
export minimum_degree
export slater_number
export sub_k_domination_number
export sub_total_k_domination_number

end
