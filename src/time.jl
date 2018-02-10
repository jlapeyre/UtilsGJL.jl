mstosec(t) = t/1000
sectomin(t) = t/60
mintohrs(t) = t/60
mstohrs(t) = t |> mstosec |> sectomin |> mintohrs

"""
    hoursfloat(t::Dates.Millisecond)::Float64

Convert `t` to hours.
"""
hoursfloat(t::Dates.Millisecond)::Float64 = t.value |> mstohrs

nothing
