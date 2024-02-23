"""
    draw(g::AbstractGraph, optset::AbstractOptimalNodeSet)

Draw a graph with the optimal node set highlighted.

# Arguments
- `g::AbstractGraph`: The graph to draw.
- `optset::AbstractOptimalNodeSet`: The optimal node set.

# Returns
- A plot of the graph with the optimal node set highlighted.
"""
function draw(
    g::AbstractGraph,
    optset::AbstractOptimalNodeSet,
)
    # Create a default color array filled with blue for each node
    nodecolors = [
        Colors.@colorant_str("lightblue") for _ in 1:Graphs.nv(g)
    ]

    # Update the color for nodes that are in the optimal set
    for node in optset.nodes
        nodecolors[node] = Colors.@colorant_str("lightgreen")
    end

    # Plot the graph with the color scheme
    plot = gplot(
        g,
        nodefillc=nodecolors,
        nodelabel=Graphs.vertices(g),
        layout=stressmajorize_layout
    )

    return plot
end

"""
    draw(g::AbstractGraph, optset::AbstractOptimalEdgeSet)

Draw a graph with the optimal edge set highlighted.

# Arguments
- `g::AbstractGraph`: The graph to draw.
- `optset::AbstractOptimalEdgeSet`: The optimal edge set.

# Returns
- A plot of the graph with the optimal edge set highlighted.
"""
function draw(
    g::AbstractGraph,
    optset::AbstractOptimalEdgeSet,
)

    # initialize array of colors for each edge
    edgecolors = [
        Colors.@colorant_str("lightblue") for _ in 1:Graphs.ne(g)
    ]

    # Update the color for edges that are in the optimal set using enumeration of edges
    for (i, edge) in enumerate(edges(g))
        if edge in optset.edges
            edgecolors[i] = Colors.@colorant_str("red")
        end
    end

    # Plot the graph with the color scheme
    plot = gplot(
        g,
        edgestrokec=edgecolors,
        nodelabel=Graphs.vertices(g),
        layout=stressmajorize_layout
    )

    return plot
end
