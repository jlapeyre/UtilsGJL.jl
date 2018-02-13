__precompile__()

"""
    module UtilsGJL

A collection of miscellaneous utilities.

EXPORTED FUNCTIONS:

`nonunique`, `nonuniquecount`, `merge1`, `merge1!`, `subst!`, `append`, `arrcountmap`,
`keepkeys`, `arraytodict`, `equalelements`, `allkeysequal`, `countmaptypes`, `countmapvalues`, `sortcountmap`,
`mapdictcol`, `foreachdict`, `compactstring`,
`truncfloat`, `rgbtohex`, `hoursfloat`, `daysfloat`, `yearsfloat`, `minutesfloat`,
`loghistogram`, `writeloghist`
"""
module UtilsGJL

using Compat
using DataStructures
using StatsBase
#using StatsBase: countmap

export keepkeys, arraytodict, hoursfloat, daysfloat, yearsfloat, minutesfloat
export equalelements, allkeysequal, countmaptypes, countmapvalues, countmapnumvalues, countmaptypenumvalues
export truncfloat, subst!, append, arrcountmap, loghistogram, writeloghist
export foreachdict
export merge1, merge1!, nonunique, nonuniquecount
export rgbtohex
export sortcountmap, mapdictcol

include("datastructures.jl")
include("strings.jl")
include("utils.jl")
include("time.jl")

end # module UtilsGJL
