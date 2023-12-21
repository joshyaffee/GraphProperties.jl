module Basics

using Graphs

include(joinpath(@__DIR__, "diameter.jl"))
include(joinpath(@__DIR__, "girth.jl"))
include(joinpath(@__DIR__, "is_free.jl"))
include(joinpath(@__DIR__, "radius.jl"))
include(joinpath(@__DIR__, "size.jl"))
include(joinpath(@__DIR__, "order.jl"))

export diameter
export girth
export is_bull_free
export is_claw_free
export is_triangle_free
export radius
export size
export order

end
