__precompile__()

module UtilsGJL

using Compat
import DataStructures
using StatsBase: countmap

export equalelements, allkeysequal, countmaptypes, countmapvalues, countmapnumvalues, countmaptypenumvalues
export foreachdict
export merge1, merge1!, nonunique, nonuniquecount
export rgbtohex
export sortcountmap, mapdictcol



include("datastructures.jl")
include("strings.jl")
include("utils.jl")

end # module UtilsGJL
