__precompile__()

"""
    module UtilsGJL

A collection of miscellaneous utilities.

EXPORTED FUNCTIONS:

`nonunique`, `nonuniquecount`, `merge1`, `merge1!`, `subst!`, `append`, `arrcountmap`,
`keepkeys`, `arraytodict`, `equalelements`, `allkeysequal`, `countmaptypes`, `countmapvalues`, `sortcountmap`,
`mapdictcol`, `foreachdict`, `compactstring`,
`truncfloat`, `rgbtohex`, `hoursfloat`, `daysfloat`, `yearsfloat`, `minutesfloat`,
`loghistogram`, `writeloghist`,
`longdisplay`,`ld`
"""
module UtilsGJL

using Compat

if isdefined(Main,:nonunique)
    import Main: nonunique
end

# if isdefined(Main,:DataFrames)
#     import DataFrames: nonunique
# end

using DataStructures
using StatsBase

export keepkeys, arraytodict, hoursfloat, daysfloat, yearsfloat, minutesfloat
export equalelements, allkeysequal, countmaptypes, countmapvalues, countmapnumvalues, countmaptypenumvalues
export truncfloat, subst!, append, arrcountmap, loghistogram, writeloghist
export foreachdict
export merge1, merge1!, nonunique, nonuniquecount
export rgbtohex
export sortcountmap, mapdictcol
export longdisplay,ld

if isdefined(:DataFrames)
    import DataFrames: nonunique
end

include("datastructures.jl")
include("strings.jl")
include("utils.jl")
include("time.jl")
include("io.jl")

end # module UtilsGJL
