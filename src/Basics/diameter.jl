"""
    diameter(g::AbstractGraph{T}) where T <: Integer

Return the diameter of `g`.

"""
function diameter(g::SimpleGraph{T}) where T <: Integer
    return Graphs.diameter(g)
end
