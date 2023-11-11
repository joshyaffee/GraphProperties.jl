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
