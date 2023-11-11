using Test
using Graphs


@testset "GraphProperties.Invariants.jl" begin
    using Graphs
    using GraphProperties.Invariants

    include("invariant_tests.jl")
end
