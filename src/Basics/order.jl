
"""
    order(g::AbstractGraph{T}) where T <: Integer

Return the order (the number of vertices) of `g`.

"""
function order(g::AbstractGraph{T},) where T <: Integer
    return Graphs.nv(g)
end