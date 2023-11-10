using Test
using Graphs
using GraphProperties.Invariants

@testset "GraphProperties.Invariants.jl" begin

    # The Petersen graph.
    g = Graphs.PetersenGraph()

    # In case of deprecation, manually construct PetersenGraph
    # g = Graphs.SimpleGraph(10)
    # add_edge!(g, 1, 2)
    # add_edge!(g, 2, 3)
    # add_edge!(g, 3, 4)
    # add_edge!(g, 4, 5)
    # add_edge!(g, 5, 1)

    # add_edge!(g, 1, 6)
    # add_edge!(g, 2, 7)
    # add_edge!(g, 3, 8)
    # add_edge!(g, 4, 9)
    # add_edge!(g, 5, 10)

    # add_edge!(g, 6, 8)
    # add_edge!(g, 8, 10)
    # add_edge!(g, 10, 7)
    # add_edge!(g, 7, 9)
    # add_edge!(g, 9, 6)


    # The 4-clique graph.
    h = Graphs.complete_graph(4)

    c5 = Graphs.SimpleGraph(5)
    add_edge!(c5, 1, 2)
    add_edge!(c5, 2, 3)
    add_edge!(c5, 3, 4)
    add_edge!(c5, 4, 5)
    add_edge!(c5, 5, 1)

    s22 = Graphs.SimpleGraph(6)
    add_edge!(s22, 1, 2)
    add_edge!(s22, 1, 3)
    add_edge!(s22, 1, 4)
    add_edge!(s22, 4, 5)
    add_edge!(s22, 4, 6)


    @testset "Independence" begin

        @testset "Petersen Graph Tests" begin
            max_ind_set = compute(MaximumIndependentSet, g)
            @test !isempty(max_ind_set.nodes)
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
            @test !isempty(max_clique.nodes)
            @test compute(CliqueNumber, h) == 4
        end

    end

    @testset "Dominating Tests" begin

        @testset "Petersen Graph Tests" begin
            min_dom_set = compute(MinimumDominatingSet, g)
            @test !isempty(min_dom_set.nodes)
            @test compute(DominationNumber, g) == 3
        end

        @testset "Clique Graph Tests" begin
            @test compute(DominationNumber, h) == 1
        end

    end

    @testset "Total Dominating Tests" begin

        @testset "Petersen Graph Tests" begin
            min_tot_dom_set = compute(MinimumTotalDominatingSet, g)
            @test !isempty(min_tot_dom_set.nodes)
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

    @testset "Diameter Tests" begin

        @testset "Petersen Graph Tests" begin
            @test compute(Diameter, g) == 2
        end

        @testset "Clique Graph Tests" begin
            @test compute(Diameter, h) == 1
        end
    end

    @testset "MinimumEdgeDominatingSet" begin
        @testset "Petersen Graph Tests" begin
            true_edge_array_set = [
                [(1,5), (7,9), (8,3)],
                [(2,1), (8,10), (9,4)],
                [(3,2), (9,6), (10,5)],
                [(4,3), (10,7), (6,1)],
                [(5,4), (6,8), (7,2)]
            ]
            test_edge_array = compute(MinimumEdgeDominatingSet, g)
            @test any([test_edge_array == MinimumEdgeDominatingSet(true_edge_array) for true_edge_array in true_edge_array_set])
        end

        @testset "K4 Graph Tests" begin
            # any two distinct edges are valid
            edge_lst = [(1,2), (1,3), (1,4), (2,3), (2,4), (3,4)]
            true_edge_array_set = [
                [edge1, edge2] for edge1 in edge_lst for edge2 in edge_lst if edge1 != edge2
            ]
            test_edge_array = compute(MinimumEdgeDominatingSet, h)
            @test any([test_edge_array == MinimumEdgeDominatingSet(true_edge_array) for true_edge_array in true_edge_array_set])
        end
        
        @testset "C5 Graph Tests" begin
            # any two edges that share no vertices are valid
            edge_lst = [(1,2), (1,3), (1,4), (1,5), (2,3), (2,4), (2,5), (3,4), (3,5), (4,5)]
            true_edge_array_set = [
                [edge1, edge2] for edge1 in edge_lst for edge2 in edge_lst if edge1[1] != edge2[1] && edge1[1] != edge2[2] && edge1[2] != edge2[1] && edge1[2] != edge2[2]
            ]
            test_edge_array = compute(MinimumEdgeDominatingSet, c5)
            @test any([test_edge_array == MinimumEdgeDominatingSet(true_edge_array) for true_edge_array in true_edge_array_set])
        end

        @testset "S22 Graph Tests" begin
            true_edge_array_set = [[(1,4)]]
            test_edge_array = compute(MinimumEdgeDominatingSet, s22)
            @test any([test_edge_array == MinimumEdgeDominatingSet(true_edge_array) for true_edge_array in true_edge_array_set])
        end
    
    end
end