@testset "GraphProperties.Communities.jl" begin
    # The 4 star graph.
    g1 = Graphs.SimpleGraph(5)
    add_edge!(g1, 1, 2)
    add_edge!(g1, 1, 3)
    add_edge!(g1, 1, 4)
    add_edge!(g1, 1, 5)

    # # a WeightedDiGraph grid
    # g2 = WeightedDiGraph(9) # need to implement this?
    # add_edge!(g2, 1, 2, 2.0)
    # add_edge!(g2, 1, 4, 1.0)
    # add_edge!(g2, 2, 3, 2.0)
    # add_edge!(g2, 2, 5, 1.0)
    # add_edge!(g2, 3, 6, 1.0)
    # add_edge!(g2, 4, 5, 2.0)
    # add_edge!(g2, 4, 7, 1.0)
    # add_edge!(g2, 5, 6, 2.0)
    # add_edge!(g2, 5, 8, 1.0)
    # add_edge!(g2, 6, 9, 1.0)
    # add_edge!(g2, 7, 8, 2.0)
    # add_edge!(g2, 8, 9, 2.0)

    # # periodic, weighted grid
    # g3 = copy(g2)
    # add_edge!(g3, 9, 1, 1.0)



    @testset "Adaptive PageRank" begin
        π = compute(PageRank(d = .85, tol = 1e-15, max_iter = 1_000, method_name = "adaptive"), g1)
        ans = [.5, .125, .125, .125, .125]
        @test all(π .≥ ans .- .001) && all(π .≤ ans .+ .001)
    end
end