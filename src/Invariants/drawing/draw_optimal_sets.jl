function draw_optimal_set(
    g::AbstractGraph,
    optset::AbstractOptimalNodeSet
)
    # Create a default color array filled with blue for each node
    nodecolors = [colorant"lightblue" for _ in 1:nv(g)]

    # Update the color for nodes that are in the optimal set
    for node in optset.nodes
        nodecolors[node] = colorant"lightgreen"
    end

    # Plot the graph with the color scheme
    gplot(
        g,
        nodefillc=nodecolors,
        nodelabel=vertices(g),
        layout=stressmajorize_layout
    )
end