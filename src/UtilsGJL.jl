__precompile__()

"""
    module UtilsGJL

A collection of miscellaneous utilities.

EXPORTED FUNCTIONS:

`nonunique`, `nonuniquecount`, `merge1`, `merge1!`,
`keepkeys`, `equalelements`, `allkeysequal`, `countmaptypes`, `countmapvalues`, `sortcountmap`,
`mapdictcol`, `foreachdict`

`truncfloat`, `rgbtohex`, `hoursfloat`
"""
module UtilsGJL

using Compat
import DataStructures
using StatsBase
#using StatsBase: countmap

export keepkeys, hoursfloat
export equalelements, allkeysequal, countmaptypes, countmapvalues, countmapnumvalues, countmaptypenumvalues
export truncfloat
export foreachdict
export merge1, merge1!, nonunique, nonuniquecount
export rgbtohex
export sortcountmap, mapdictcol

include("datastructures.jl")
include("strings.jl")
include("utils.jl")
include("time.jl")

end # module UtilsGJL
