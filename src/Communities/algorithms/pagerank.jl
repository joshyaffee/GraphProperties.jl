"""
    compute(algo::PageRank, g::AbstractGraph)::Vector{Float64}

Compute the PageRank values of the nodes in graph `g` using the specified PageRank algorithm.

# Arguments

- `algo::PageRank`: The PageRank algorithm configuration object. This should contain properties like
  (initial) damping factor (`d`), maximum number of iterations (`max_iter`), tolerance (`tol`), and the method:
  "classical", "iterative", or "adaptive" (method_name). The two latter methods are described in the paper
  PageRank: New Regularizations and Simulation Models (2011) by Boris T. Polyak and Anna V. Timonina

- `g::AbstractGraph`: The graph for which to compute the PageRank. This can be a simple graph, directed or
  undirected, or a weighted version of these.

# Returns

- A vector of `Float64` where each entry represents the PageRank value of the corresponding node in the graph.

# Details

The function uses the power iteration method to find the principal eigenvector of an altered adjacency matrix.
The altered matrix is created by 'damping' the original matrix, which is done by adding a constant to each entry
as well as taking care of sinks. The iterative and adaptive methods increase the damping factor (decreases perturbance of P) 
as the algorithm progresses, which is shown to improve convergence. The iterative method increases the damping factor
over a determined sequence, while the adaptive method maintains the damping factor until a relaxed tolerance is reached, 
then lowers the tolerance and repeats until the original tolerance is reached.

```julia
julia> g = generate(PlantedPartition())

julia> algo = PageRank(d=0.85, max_iter=100, tol=1e-6, method_name="adaptive")

julia> compute(algo, g)
"""
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

"""
    _classical_pagerank(P::SparseMatrixCSC, d::Float64, tol::Float64, max_iter::Int64)::Vector{Float64}

Helper function for compute(Pagerank, g), computes the PageRank values of the nodes in graph `g` using the classical PageRank algorithm.

# Arguments

- `P::SparseMatrixCSC`: The Markov Chain associated with `g`.
- `d::Float64`: The damping factor.
- `tol::Float64`: The tolerance for convergence.
- `max_iter::Int64`: The maximum number of iterations.

# Returns

- A vector of `Float64` where each entry represents the PageRank value of the corresponding node in the graph.
"""
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

"""
    _iterative_pagerank(P::SparseMatrixCSC, d::Float64, tol::Float64, max_iter::Int64)::Vector{Float64}

Helper function for compute(Pagerank, g), computes the PageRank values of the nodes in graph `g` using the iterative regularization PageRank algorithm.

# Arguments

- `P::SparseMatrixCSC`: The Markov Chain associated with `g`.
- `d::Float64`: The initial damping factor, from which the regularization factor is computed. 0 < d < .5
- `tol::Float64`: The tolerance for convergence.
- `max_iter::Int64`: The maximum number of iterations.

# Returns

- A vector of `Float64` where each entry represents the PageRank value of the corresponding node in the graph.
"""
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

"""
    _adaptive_pagerank(P::SparseMatrixCSC, d::Float64, tol::Float64, max_iter::Int64)::Vector{Float64}

Helper function for compute(Pagerank, g), computes the PageRank values of the nodes in graph `g` using the adaptive regularization PageRank algorithm.

# Arguments

- `P::SparseMatrixCSC`: The Markov Chain associated with `g`.
- `d::Float64`: The initial damping factor. 0 < d < 1.0
- `tol::Float64`: The tolerance for convergence.
- `max_iter::Int64`: The maximum number of iterations.

# Returns

- A vector of `Float64` where each entry represents the PageRank value of the corresponding node in the graph.
"""
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