function draw_optimal_set(
    g::AbstractGraph,
    optset::AbstractOptimalNodeSet
)
    # Create a default color array filled with blue for each node
    nodecolors = [colorant"lightblue" for _ in 1:Graphs.nv(g)]

    # Update the color for nodes that are in the optimal set
    for node in optset.nodes
        nodecolors[node] = colorant"lightgreen"
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

function draw_optimal_set(
    g::AbstractGraph,
    optset::AbstractOptimalEdgeSet
)

    # initialize array of colors for each edge
    edgecolors = [colorant"lightblue" for _ in 1:Graphs.ne(g)]

    # Update the color for edges that are in the optimal set using enumeration of edges
    for (i, edge) in enumerate(edges(g))
        if edge in optset.edges
            edgecolors[i] = colorant"lightgreen"
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
