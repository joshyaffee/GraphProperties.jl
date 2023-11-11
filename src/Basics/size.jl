
"""
    size(g::AbstractGraph{T}) where T <: Integer

Return the size (the number of edges) of `g`.

"""
function size(g::AbstractGraph{T},) where T <: Integer
    return Graphs.ne(g)
end