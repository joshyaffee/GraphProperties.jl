
@testset "GraphIO.jl Tests" begin
    @testset "Read .txt file test" begin
        path = joinpath(@__DIR__, "double_star_s22.txt")
        g = load_edgelist(path)
        @test Graphs.nv(g) == 6
        @test Graphs.ne(g) == 5
    end

    @testset "Read .csv file test" begin
        path = joinpath(@__DIR__, "double_star_s22.csv")
        g = load_edgelist(path)
        @test Graphs.nv(g) == 6
        @test Graphs.ne(g) == 5
    end

    @testset "write_edgelist! to .txt test" begin
        g = SimpleGraph(3)
        add_edge!(g, 1, 2)
        add_edge!(g, 2, 3)

        # Create a temporary file.
        mktemp() do path, io
            # Close the io handle immediately, we just need the path.
            close(io)

            # Call the function to test.
            write_edgelist!(g, path, TXTFormat())

            # Now read the file back in and test that it was written correctly.
            content = read(path, String)

            # Define the expected content for comparison.
            expected_content = "1 2\n2 3\n"

            # Test if the content is equal.
            @test content == expected_content
        end
        # Temporary file is automatically deleted when the block ends.
    end

    @testset "write_edgelist! to .csv test" begin
        g = SimpleGraph(3)
        add_edge!(g, 1, 2)
        add_edge!(g, 2, 3)

        # Create a temporary file.
        mktemp() do path, io
            # Close the io handle immediately, we just need the path.
            close(io)

            # Call the function to test.
            write_edgelist!(g, path, CSVFormat())

            # Now read the file back in and test that it was written correctly.
            df = CSV.read(path, DataFrame)

            # Define the expected dataframe for comparison.
            expected_df = DataFrame(source=[1, 2], destination=[2, 3])

            # Test if the dataframes are equal.
            @test df == expected_df
        end
        # Temporary file is automatically deleted when the block ends.
    end
end
