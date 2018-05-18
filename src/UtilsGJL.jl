__precompile__()

"""
    module UtilsGJL

A collection of miscellaneous utilities.

EXPORTED FUNCTIONS:

`nonunique`, `nonuniquecount`, `merge1`, `merge1!`, `subst!`, `append`, `arrcountmap`,
`keepkeys`, `arraytodict`, `equalelements`, `allkeysequal`, `countmaptypes`, `countmapvalues`, `sortcountmap`,
`foreachdict`, `compactstring`,
`truncfloat`, `rgbtohex`, `hoursfloat`, `daysfloat`, `yearsfloat`, `minutesfloat`,
`loghistogram`, `writeloghist`,
`longdisplay`,`ld`, `alldocs`,
`@withw`
"""
module UtilsGJL

# The following works in some situations, at the cost of loading
# DataFrames.

if isdefined(Main,:DataFrames)
     import DataFrames: nonunique
end

using Compat

using DataStructures
using StatsBase

export keepkeys, arraytodict, hoursfloat, daysfloat, yearsfloat, minutesfloat
export equalelements, allkeysequal, countmaptypes, countmapvalues, countmapnumvalues, countmaptypenumvalues
export truncfloat, subst!, append, arrcountmap, loghistogram, writeloghist
export foreachdict
export merge1, merge1!, nonunique, nonuniquecount
export rgbtohex
export sortcountmap
export longdisplay,ld
export alldocs
export @withw

include("datastructures.jl")
include("strings.jl")
include("utils.jl")
include("time.jl")
include("io.jl")
include("docs.jl")

end # module UtilsGJL
