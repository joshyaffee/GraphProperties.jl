@testset "GraphProperties.Basics.jl" begin
    # create graphs to test basics:
        # 1) empty graph - we ignore this case
        # 2) complete 5 graph
        # 3) graph with 1 claw and 1 bull
        # 4) bipartite K_2,3 graph
        # 5) C_9 graph

    # g_1 = Graphs.SimpleGraph(0) # we ignore this case

    g_2 = Graphs.complete_graph(5)

    g_3 = Graphs.SimpleGraph(8)
    add_edge!(g_3, 1, 2)
    add_edge!(g_3, 1, 3)
    add_edge!(g_3, 1, 4)
    add_edge!(g_3, 1, 5)
    add_edge!(g_3, 1, 6)
    add_edge!(g_3, 2, 4)
    add_edge!(g_3, 2, 7)
    add_edge!(g_3, 4, 8)

    g_4 = Graphs.SimpleGraph(5)
    for i in 1:3
        for j in 4:5
            add_edge!(g_4, i, j)
        end
    end

    g_5 = Graphs.SimpleGraph(9)
    for i in 1:9
        add_edge!(g_5, i, (i % 9) + 1)
    end

    @testset "diameter" begin
        @test diameter(g_2) == 1
        @test diameter(g_3) == 3
        @test diameter(g_4) == 2
        @test diameter(g_5) == 4
    end

    @testset "radius" begin
        @test radius(g_2) == 1
        @test radius(g_3) == 2
        @test radius(g_4) == 2
        @test radius(g_5) == 4
    end

    @testset "girth" begin
        @test girth(g_2) == 3
        @test girth(g_3) == 3
        @test girth(g_4) == 4
        @test girth(g_5) == 9
    end

    @testset "is_triangle_free" begin
        @test is_triangle_free(g_2) == false
        @test is_triangle_free(g_3) == false
        @test is_triangle_free(g_4) == true
        @test is_triangle_free(g_5) == true
    end

    @testset "is_claw_free" begin
        @test is_claw_free(g_2) == true
        @test is_claw_free(g_3) == false
        @test is_claw_free(g_4) == false
        @test is_claw_free(g_5) == true
    end

    @testset "is_bull_free" begin
        @test is_bull_free(g_2) == true
        @test is_bull_free(g_3) == false
        @test is_bull_free(g_4) == true
        @test is_bull_free(g_5) == true
    end

    @testset "order" begin
        @test GraphProperties.Basics.order(g_2) == 5
        @test GraphProperties.Basics.order(g_3) == 8
        @test GraphProperties.Basics.order(g_4) == 5
        @test GraphProperties.Basics.order(g_5) == 9
    end

    @testset "size" begin
        @test size(g_2) == 10
        @test size(g_3) == 8
        @test size(g_4) == 6
        @test size(g_5) == 9
    end
end