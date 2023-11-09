module GraphProperties


# Import the Invariants module
include(joinpath(@__DIR__, "Invariants", "Invariants.jl"))
using .Invariants

# Import the Communities module
include(joinpath(@__DIR__, "Communities", "Communities.jl"))
using .Communities

end
