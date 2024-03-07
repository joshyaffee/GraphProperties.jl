
# encapsulate G'' separately, as it will be moved to a separate module later
function construction2(
    c_size:: Int,
    k_sizes:: Union{Array{Int, 1}, Int}
    )

    # Throw exception if k_sizes is an array and does not have length c_size
    k_sizes isa Array{Int, 1} &&
        (length(k_sizes) != c_size) &&
        throw(ArgumentError("k_sizes must have length equal to c_size or be an integer"))

    # determine k_sizes vector depending on type provided
    k_sizes isa Int && (k_sizes = fill(k_sizes, c_size))

    # initialize G'' nodes
    G2 = Graphs.SimpleGraph(c_size + sum(k_sizes))

    # add edges within cycle
    for i in 1:c_size
        add_edge!(G2, i, (i % c_size) + 1)
    end

    # For i = 1, . . . k, attach each vertex of K^i_ni to both vi and vi+1 (with i = i mod k)
    top_node_used = c_size
    for (i, k_size) in enumerate(k_sizes)
        for j in 1:k_size

            # connect each node to the cycle
            add_edge!(G2, top_node_used + j, i)
            add_edge!(G2, top_node_used + j, (i % c_size) + 1) 

            # make clique by connecting each node with previously added nodes
            for k in (top_node_used + 1):(top_node_used + j - 1)
                add_edge!(G2, top_node_used + j, k)
            end
        end

        # update top_node_used
        top_node_used += k_size
    end

    return G2
end


@testset "GraphProperties.Invariants.jl" begin

    g = Graphs.SimpleGraph(10)
    add_edge!(g, 1, 2)
    add_edge!(g, 2, 3)
    add_edge!(g, 3, 4)
    add_edge!(g, 4, 5)
    add_edge!(g, 5, 1)

    add_edge!(g, 1, 6)
    add_edge!(g, 2, 7)
    add_edge!(g, 3, 8)
    add_edge!(g, 4, 9)
    add_edge!(g, 5, 10)

    add_edge!(g, 6, 8)
    add_edge!(g, 8, 10)
    add_edge!(g, 10, 7)
    add_edge!(g, 7, 9)
    add_edge!(g, 9, 6)


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

    g2 = construction2(6,[1,2,3,1,2,3])
    # g2_lg = construction2(15,[1,2,3,1,2,3,1,2,3,1,2,3,1,2,3])

    @testset "Independence" begin

        @testset "Petersen Graph Tests" begin
            max_ind_set = compute(MaximumIndependentSet, g)
            @test !isempty(max_ind_set.nodes)
            @test independence_number(g) == 4
        end

        @testset "Clique Graph Tests" begin
            @test independence_number(h) == 1
        end
    end

    @testset "Clique Tests" begin

        @testset "Petersen Graph Tests" begin
            @test clique_number(g) == 2
        end

        @testset "Clique Graph Tests" begin
            max_clique = compute(MaximumClique, h)
            @test !isempty(max_clique.nodes)
            @test clique_number(h) == 4
        end

    end

    @testset "Dominating Tests" begin

        @testset "Petersen Graph Tests" begin
            min_dom_set = compute(MinimumDominatingSet, g)
            @test !isempty(min_dom_set.nodes)
            @test domination_number(g) == 3
        end

        @testset "Clique Graph Tests" begin
            @test domination_number(h) == 1
        end

    end

    @testset "Total Dominating Tests" begin

        @testset "Petersen Graph Tests" begin
            min_tot_dom_set = compute(MinimumTotalDominatingSet, g)
            @test !isempty(min_tot_dom_set.nodes)
            @test total_domination_number(g) == 4
        end

        @testset "Clique Graph Tests" begin
            @test total_domination_number(h) == 2
        end
    end

    @testset  "Other Domination Tests" begin
        # to test:
            # 1. LocatingDominationNumber / Set
            # 2. PairedDominationNumber / Set
            # 3. IndependentDominationNumber / Set
            # 4. PowerDominationNumber / Set
        
        @testset "S-22 Graph Tests" begin
            @test locating_domination_number(s22) == 4
            @test paired_domination_number(s22) == 2
            @test independent_domination_number(s22) == 3
            @test power_domination_number(s22) == 2
        end

        @testset "Petersen Graph Tests" begin
            @test locating_domination_number(g) == 4
            @test paired_domination_number(g) == 6
            @test independent_domination_number(g) == 3
            @test power_domination_number(g) == 2
        end

    end

    @testset "Zero Forcing Tests" begin

        @testset "Petersen Graph Tests" begin
            @test zero_forcing_number(g) == 5
        end

        @testset "Clique Graph Tests" begin
            @test zero_forcing_number(h) == 3
        end

        @testset "G2 Construction Tests" begin
            @test zero_forcing_number(g2) == nv(g2) - independence_number(g2)
            # test this next, I think the answer is 1 off, do some drawing maybe
            # takes ~ 13 minutes
            # @test zero_forcing_number(g2_lg) == nv(g2_lg) - independence_number(g2_lg)
        end
    end

    @testset "Chromatic Number Tests" begin

        @testset "Petersen Graph Tests" begin
            @test chromatic_number(g) == 3
        end

        @testset "Clique Graph Tests" begin
            @test chromatic_number(h) == 4
        end
    end

    @testset "Girth" begin

        @testset "Petersen Graph Tests" begin
            @test girth(g) == 5
        end

        @testset "Clique Graph Tests" begin
            @test girth(h) == 3
        end
    end

    @testset "Diameter Tests" begin

        @testset "Petersen Graph Tests" begin
            @test GraphProperties.diameter(g) == 2
        end

        @testset "Clique Graph Tests" begin
            @test GraphProperties.diameter(h) == 1
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
                [edge1, edge2] for edge1 in edge_lst
                for edge2 in edge_lst
                    if edge1 != edge2
            ]
            test_edge_array = compute(MinimumEdgeDominatingSet, h)
            @test any(
                [
                    test_edge_array == MinimumEdgeDominatingSet(true_edge_array)
                    for true_edge_array in true_edge_array_set
                ]
            )
        end

        @testset "C5 Graph Tests" begin
            # any two edges that share no vertices are valid
            edge_lst = [
                (1,2), (1,3), (1,4), (1,5), (2,3),
                (2,4), (2,5), (3,4), (3,5), (4,5)
            ]
            true_edge_array_set = [
                [edge1, edge2] for edge1 in edge_lst
                for edge2 in edge_lst
                    if edge1[1] != edge2[1]
                        && edge1[1] != edge2[2]
                        && edge1[2] != edge2[1]
                        && edge1[2] != edge2[2]
            ]
            test_edge_array = compute(MinimumEdgeDominatingSet, c5)
            @test any(
                [
                    test_edge_array == MinimumEdgeDominatingSet(true_edge_array)
                    for true_edge_array in true_edge_array_set
                ]
            )
        end

        @testset "S22 Graph Tests" begin
            true_edge_array_set = [[(1,4)]]
            test_edge_array = compute(MinimumEdgeDominatingSet, s22)
            @test any(
                [
                    test_edge_array == MinimumEdgeDominatingSet(true_edge_array)
                    for true_edge_array in true_edge_array_set
                ]
            )
        end

    end
end