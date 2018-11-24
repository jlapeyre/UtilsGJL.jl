import Dates

mstosec(t) = t/1000
sectomin(t) = t/60
mintohrs(t) = t/60
hrstodays(t) = t/24
daystoyears(t) = t/365

mstomin(t) = t |> mstosec |> sectomin
mstohrs(t) = t |>  mstomin |> mintohrs
mstodays(t) = t |> mstohrs |> hrstodays
mstoyears(t) = t |> mstodays |> daystoyears

"""
    secondsfloat(t::Dates.Millisecond)::Float64

Convert `t` to seconds.
"""
secondsfloat(t::Dates.Millisecond)::Float64 = t.value |> mstosec

"""
    minutesfloat(t::Dates.Millisecond)::Float64

Convert `t` to minutes.
"""
minutesfloat(t::Dates.Millisecond)::Float64 = t.value |> mstomin


"""
    hoursfloat(t::Dates.Millisecond)::Float64

Convert `t` to hours.
"""
hoursfloat(t::Dates.Millisecond)::Float64 = t.value |> mstohrs

"""
    daysfloat(t::Dates.Millisecond)::Float64

Convert `t` to days.
"""
daysfloat(t::Dates.Millisecond)::Float64 = t.value |> mstodays

"""
    yearsfloat(t::Dates.Millisecond)::Float64

Convert `t` to years.
"""
yearsfloat(t::Dates.Millisecond)::Float64 = t.value |> mstoyears


nothing
