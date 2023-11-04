using Test

@testset "GraphProperties.Invariants.jl" begin
    using Graphs
    using GraphProperties.Invariants

    # The Petersen graph.
    g = Graphs.PetersenGraph()

    # The 4-clique graph.
    h = Graphs.complete_graph(4)

    @testset "Independence" begin

        @testset "Petersen Graph Tests" begin
            max_ind_set = compute(MaximumIndependentSet, g)
            @test max_ind_set.nodes == [1, 3, 9, 10]
            @test compute(IndependenceNumber, g) == 4
        end

        @testset "Clique Graph Tests" begin
            @test compute(IndependenceNumber, h) == 1
        end
    end

    @testset "Clique Tests" begin

        @testset "Petersen Graph Tests" begin
            @test compute(CliqueNumber, g) == 2
        end

        @testset "Clique Graph Tests" begin
            max_clique = compute(MaximumClique, h)
            @test max_clique.nodes == [1, 2, 3, 4]
            @test compute(CliqueNumber, h) == 4
        end

    end

    @testset "Dominating Tests" begin

        @testset "Petersen Graph Tests" begin
            min_dom_set = compute(MinimumDominatingSet, g)
            @test min_dom_set.nodes == [3, 6, 10]
            @test compute(DominationNumber, g) == 3
        end

        @testset "Clique Graph Tests" begin
            @test compute(DominationNumber, h) == 1
        end

    end

    @testset "Total Dominating Tests" begin

        @testset "Petersen Graph Tests" begin
            min_tot_dom_set = compute(MinimumTotalDominatingSet, g)
            @test min_tot_dom_set.nodes == [1, 2, 3, 7]
            @test compute(TotalDominationNumber, g) == 4
        end

        @testset "Clique Graph Tests" begin
            @test compute(TotalDominationNumber, h) == 2
        end
    end

    @testset "Zero Forcing Tests" begin

        @testset "Petersen Graph Tests" begin
            @test compute(ZeroForcingNumber, g) == 5
        end

        @testset "Clique Graph Tests" begin
            @test compute(ZeroForcingNumber, h) == 3
        end
    end

    @testset "Chromatic Number Tests" begin

        @testset "Petersen Graph Tests" begin
            @test compute(ChromaticNumber, g) == 3
        end

        @testset "Clique Graph Tests" begin
            @test compute(ChromaticNumber, h) == 4
        end
    end

    @testset "Girth" begin

        @testset "Petersen Graph Tests" begin
            @test compute(Girth, g) == 5
        end

        @testset "Clique Graph Tests" begin
            @test compute(Girth, h) == 3
        end
    end
end
