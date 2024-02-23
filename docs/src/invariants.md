# Invariants

The `Invariants` module provides functions to compute invariants for a given graph. These
invariants can categorized into these general categories:

1. Chromatic Colorings
2. Cliques
3. Domination
4. Independence
5. Matching
6. Zero Forcing

Methods use several optimization approaches including integer programming which is handled
through `JuMP` and uses the default optimizer `HiGHS`.

```@autodocs
Modules = [GraphProperties.Invariants]
```