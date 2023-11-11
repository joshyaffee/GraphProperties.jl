module Basics

using Graphs

include(joinpath(@__DIR__, "diameter.jl"))
include(joinpath(@__DIR__, "girth.jl"))
include(joinpath(@__DIR__, "radius.jl"))
include(joinpath(@__DIR__, "size.jl"))
include(joinpath(@__DIR__, "order.jl"))

export diameter
export girth
export radius
export size
export order

end
