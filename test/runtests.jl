using Test

@testset "GraphProperties.Invariants.jl Tests" begin
    using Graphs
    using GraphProperties
    using GraphProperties.Invariants: compute

    include(joinpath(@__DIR__, "Invariants","invariant_tests.jl"))
end

@testset "GraphProperties.GraphIO.jl Tests" begin
    using CSV
    using DataFrames
    using Graphs
    using GraphProperties.GraphIO: CSVFormat, load_edgelist, TXTFormat

    include(joinpath(@__DIR__, "GraphIO","graphio_tests.jl"))
end

@testset "GraphProperties.Basics.jl Tests" begin
    using Graphs
    using GraphProperties
    using GraphProperties.Basics: diameter, girth, is_bull_free, is_claw_free, is_triangle_free, radius, size

    include(joinpath(@__DIR__, "Basics","basics_tests.jl"))
end