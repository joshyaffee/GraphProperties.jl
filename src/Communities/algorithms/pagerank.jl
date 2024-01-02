"""
    compute(algo::PageRank, g::AbstractGraph)::Vector{Float64}

Compute the PageRank values of the nodes in graph `g` using the PageRank algorithm.

# Arguments

- `algo::PageRank`: The PageRank algorithm configuration object. This should contain properties like
  (initial) damping factor (`d`), maximum number of iterations (`max_iter`), tolerance (`tol`), and .

- `g::AbstractGraph`: The graph for which to compute the PageRank. This can be a simple graph, directed
  graph, or a weighted version of these.

# Returns

- A vector of `Float64` where each entry represents the PageRank value of the corresponding node in the graph.

# Details

The function uses the power iteration method to compute the PageRank values. If the graph is weighted,
the weights of the edges are taken into account while calculating the rank.

The algorithm iteratively refines the PageRank values until either the maximum number of iterations
is reached or the values converge within the specified tolerance.

# Example

```julia
julia> g = generate(PlantedPartition())

julia> algo = PageRank(d=0.85, max_iter=100, tol=1e-6, method_name=")

julia> compute(algo, g)
```
"""
# function compute(algo::PageRank, g::AbstractGraph)

#     N = nv(g)
#     PR = fill(1.0 / N, N)  # Initial rank
#     old_PR = copy(PR)
#     is_weighted = isa(g, SimpleWeightedGraph) || isa(g, SimpleWeightedDiGraph)

#     # Out-Degree Weights
#     W = Vector{Float64}(undef, N)
#     for i in 1:N
#         if is_weighted
#             W[i] = sum(outneighbors(g, i) .|> out_vertex -> get_weight(g, i, out_vertex))
#         else
#             W[i] = outdegree(g, i)
#         end
#     end

#     for _ in 1:algo.max_iter
#         for i in 1:N
#             s = 0.0
#             for j in inneighbors(g, i)
#                 wij = is_weighted ? get_weight(g, j, i) : 1.0
#                 s += wij * PR[j] / W[j]
#             end
#             PR[i] = (1 - algo.d) + algo.d * s
#         end

#         # Check for convergence
#         if maximum(abs.(PR - old_PR)) < algo.tol
#             break
#         end
#         old_PR = copy(PR)
#     end

#     # Normalize
#     PR ./= sum(PR)

#     return PR
# end


function compute(
    algo::PageRank,
    g::AbstractGraph
    )::Vector{Float64}

    adj_matrix = Graphs.adjacency_matrix(g)

    for (row_index, row_values) in enumerate(eachrow(adj_matrix))
        # Throw exception if there is a negative weight:
        if any(row_values .< 0)
            throw(ArgumentError("Negative weights are not supported."))
        end

        # If the row is all zeros (disregarding loops), then it is a sink. Connect it to all other nodes:
        loop = adj_matrix[row_index, row_index]
        if sum(row_values) - loop == 0.0
            adj_matrix[row_index, :] .= 1
            if loop == 0
                adj_matrix[row_index, row_index] = 0
            end
        end
    end
    
    # normalize rows to sum to 1 and transpose
    P = adj_matrix ./ sum(adj_matrix, dims=2)
    P = copy(SparseArrays.transpose(P))

    f_map = Dict("classical" => _classical_pagerank, "iterative" => _iterative_regularization_pagerank, "adaptive" => _adaptive_regularization_pagerank)

    pagerank_function = f_map[algo.method_name]
    d = algo.d
    tol = algo.tol
    max_iter = algo.max_iter

    return pagerank_function(P, d, tol, max_iter)
end  

function _classical_pagerank(
    P::SparseMatrixCSC, 
    d::Float64, 
    tol::Float64, 
    max_iter::Int64
    )::Vector{Float64}

    # initialize
    N = size(P, 1)

    pr = LinearAlgebra.ones(N) / N

    for _ in 1:max_iter
        prev_pr = copy(pr)
        # power method for principle eigenvector of modified P
        pr = d .* P * pr .+ (1 - d) / N
        
        if LinearAlgebra.norm(pr - prev_pr, 1) < tol
            return pr
        end
    end

    println("Warning: max_iter reached")
    return pr
end

function _iterative_regularization_pagerank(
    P::SparseMatrixCSC, 
    d::Float64, 
    tol::Float64, 
    max_iter::Int64
    )::Vector{Float64}

    # initialize
    N = size(P, 1)

    pr = LinearAlgebra.ones(N) / N
    # compute p for regularization factor
    p = log2(1 / (1 - d))

    # iterate until tolerance is reached or max_iter is reached
    for k in 1:max_iter
        # regularization factor
        α = 1 - 1 / ((k+2) ^ p) 

        prev_pr = copy(pr)
        # power method for principle eigenvector of modified P
        pr = α .* P * pr .+ (1 - α) / N
        
        if LinearAlgebra.norm(pr - prev_pr, 1) < tol
            println("Converged in $k iterations")
            return pr
        end
    end
    println("Warning: max_iter reached")
    
    return pr
end

function _adaptive_regularization_pagerank(
    P::SparseMatrixCSC, 
    d::Float64, 
    tol::Float64, 
    max_iter::Int64
    )::Vector{Float64}

    # initialize
    N = size(P, 1)

    prev_pr = LinearAlgebra.zeros(N)
    prev_pr[1] = 1

    pr = LinearAlgebra.ones(N) / N
    this_tol = 1 - d
    k = 0

    # continue until tolerance is reached or max_iter is reached
    while LinearAlgebra.norm(pr - prev_pr, 1) > tol

        # set damping factor to use until this tolerance is reached
        α = 1 - this_tol
        while LinearAlgebra.norm(pr - prev_pr, 1) > this_tol
            prev_pr = copy(pr)

            # power method for principle eigenvector of modified P
            pr = α .* P * pr .+ (1 - α) / N
            
            k += 1
            if k ≥ max_iter
                println("Warning: max_iter reached")
                return pr
            end
        end

        # update tolerance by halving it
        this_tol = max(tol, this_tol / 2)
    end
    
    println("Converged in $k iterations")
    return pr
end 