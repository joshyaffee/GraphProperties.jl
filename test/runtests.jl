using Test
using Graphs


@testset "GraphProperties.Invariants.jl" begin
    using Graphs
    using GraphProperties
    using GraphProperties.Invariants: compute

    include("invariant_tests.jl")
end
