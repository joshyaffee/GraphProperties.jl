
"""
    radius(g::AbstractGraph{T}) where T <: Integer

Return the radius of `g`.

"""
function radius(g::SimpleGraph{T}) where T <: Integer
    return Graphs.radius(g)
end
