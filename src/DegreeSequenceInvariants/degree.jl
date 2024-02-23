
"""
    maximum_degree(g::AbstractGraph{T}) where T <: Integer

Return the maximum degree of `g`.

"""
function maximum_degree(g::SimpleGraph{T},) where T <: Integer
    return maximum(Graphs.degree(g))
end

"""
    minimum_degree(g::AbstractGraph{T},) where T <: Integer

Return the minimum degree of `g`.

"""
function minimum_degree(g::SimpleGraph{T},) where T <: Integer
    return minimum(Graphs.degree(g))
end

"""
    average_degree(g::AbstractGraph{T}) where T <: Integer

Return the (arithmetic) average degree of `g`.

"""
function average_degree(g::SimpleGraph{T},) where T <: Integer
    return mean(Graphs.degree(g))
end