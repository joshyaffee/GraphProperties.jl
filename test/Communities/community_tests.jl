@testset "GraphProperties.Communities.jl" begin
    # The 4 star graph.
    g1 = Graphs.SimpleGraph(5)
    add_edge!(g1, 1, 2)
    add_edge!(g1, 1, 3)
    add_edge!(g1, 1, 4)
    add_edge!(g1, 1, 5)

    # a WeightedDiGraph grid
    g2_sources = [1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 8]
    g2_targets = [2, 4, 3, 5, 6, 5, 7, 6, 8, 9, 8, 9]
    g2_weights = [2.0, 1.0, 2.0, 1.0, 1.0, 2.0, 1.0, 2.0, 1.0, 1.0, 2.0, 2.0]
    g2 = SimpleWeightedDiGraph(g2_sources, g2_targets, g2_weights)

    # a periodic grid
    g3_sources = [1, 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 8, 9]
    g3_targets = [2, 4, 3, 5, 6, 5, 7, 6, 8, 9, 8, 9, 1]
    g3_weights = [2.0, 1.0, 2.0, 1.0, 1.0, 2.0, 1.0, 2.0, 1.0, 1.0, 2.0, 2.0, 1.0]
    g3 = SimpleWeightedDiGraph(g3_sources, g3_targets, g3_weights)


    @testset "Adaptive PageRank" begin
        π = compute_pagerank(PageRank(d = .85, tol = 1e-10, max_iter = 1_000, method_name = "adaptive"), g1)
        ans = [.5, .125, .125, .125, .125]
        @test all(π .≥ ans .- .001) && all(π .≤ ans .+ .001)

        π = compute_pagerank(PageRank(d = .85, tol = 1e-15, max_iter = 1_000, method_name = "adaptive"), g2)
        @test (π[2] > π[4]) && (π[6] > π[8]) && (π[9] == maximum(π))

        π = compute_pagerank(PageRank(d = .85, tol = 1e-15, max_iter = 1_000, method_name = "adaptive"), g3)
        @test (π[2] > π[4]) && (π[6] > π[8])
    end
    
    @testset "Iterative PageRank" begin
        π = compute_pagerank(PageRank(d = .425, tol = 1e-10, max_iter = 1_000, method_name = "iterative"), g1)
        ans = [.5, .125, .125, .125, .125]
        @test all(π .≥ ans .- .001) && all(π .≤ ans .+ .001)

        π = compute_pagerank(PageRank(d = .425, tol = 1e-15, max_iter = 1_000, method_name = "iterative"), g2)
        @test (π[2] > π[4]) && (π[6] > π[8]) && (π[9] == maximum(π))

        π = compute_pagerank(PageRank(d = .425, tol = 1e-15, max_iter = 1_000, method_name = "iterative"), g3)
        @test (π[2] > π[4]) && (π[6] > π[8])
    end

    @testset "Classical Pagerank" begin
        π = compute_pagerank(PageRank(d = .85, tol = 1e-10, max_iter = 1_000, method_name = "classical"), g1)
        ans1 = 0.47567668878363595
        @test π[1] ≤ ans1 + .001 && π[1] ≥ ans1 - .001
    end
end