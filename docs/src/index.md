# Welcome to GraphProperties.jl

GraphProperties.jl is a versatile Julia package designed for comprehensive analysis and
manipulation of graph properties. Seamlessly integrating two key modules - Invariants and
Communities - GraphProperties.jl offers powerful tools for computing graph invariants and
detecting community structures within networks.

The full list of modules is:

1. Basics (e.g. diameter)
2. Communities (e.g. pagerank)
3. Degree Sequence Invariants (e.g. annihilation number)
4. Draw (e.g. drawing optimal node set)
5. GraphIO (e.g. CSV formatting)
6. Graph Rules (e.g. Havel-Hakimi Rule)
7. Invariants (e.g. Maximum Matching)

### Versatility and Compatability

GraphProperties.jl's features are tailored to work with the `AbstractGraph` types from
[Graphs.jl](https://github.com/JuliaGraphs/Graphs.jl) and
[SimpleWeightedGraphs.jl](https://github.com/JuliaGraphs/SimpleWeightedGraphs.jl). Thus,
the package supports both unweighted and weighted graphs, along with a variety of graph input formats. Whether dealing with small-scale or large-scale graph analysis, GraphProperties.jl provides the flexibility and functionality needed for diverse applications.

### Performance

*Benchmarking in progress*

### Visualization

GraphProperties.jl includes tools for graph and community visualization, allowing users to illustrate the structure and properties of graphs intuitively. Visualize graph layouts, community structures, and other key properties to aid in interpretation and communication of results.

## Installation

To add GraphProperties.jl to your Julia environment, you can use the Julia package
manager. In the Julia REPL, enter the package manager by pressing `]`, then run:

```julia
(@v1.x) pkg> add https://github.com/RandyRDavila/GraphProperties.jl.git
```

After adding the package, you can start using it in your Julia sessions by importing it:

```julia
using GraphProperties
```

See our other documentation pages for usage examples.

## Authors

- **Randy R. Davila, PhD**
  - Lecturer of Computational Applied Mathematics & Operations Research at Rice University.
  - Software Engineer at RelationalAI.

- **Joshua Yaffee**
  - Rice University: Masters of Industrial Engineering
  - Data Scientist at Walmart

## Further Information

For more information and updates, you can visit the [GitHub repository](https://github.com/RandyRDavila/GraphProperties.jl.git) of GraphProperties.jl.