module UtilsGJL

import DataStructures
import StatsBase

export equalelements, allkeysequal, countmaptypes, countmapvalues, countmapnumvalues, countmaptypenumvalues
export rgbtohex

"""
    equalelements(a,b)

Returns `true` if `a` and `b` are element-wise equal, using `==`.
For arrays, this is equivalent to `a == b`. But, for some iterators
a method for `==` is not defined.

`equalelements` should give the same result as `collect(a) == collect(b)`,
but perhaps do it more efficiently as it avoids allocation.
"""
function equalelements(a,b)
    for (x,y) in zip(a,b)
        x != y && return false
    end
    return true
end

"""
    allkeysequal(a::AbstractArray)::Bool

Returns `true` only if all elements of `a` have keys and the set of keys of the first element of `a` is identical
to the set of keys of each of the other elements.
"""
#function check_key_consistency(a::AbstractArray{Associative}) #  AbstractArray{Any} also works here
function allkeysequal(a::AbstractArray)
    length(a) == 0 && return false
    ks = keys(a[1])
    for (i,obj) in enumerate(a)
        equalelements(keys(obj),  ks)  || return false
    end
    return true
end


"""
    countmaptypes(a::Array)

returns a count map of the value types for each key in elements of `a`.

`a` is an array of objects of type `Associative` with identical keys.
"""
function countmaptypes(arr::Array)
    type_counts = DataStructures.OrderedDict{String,Dict}()
    length(arr) < 1 && return type_counts
    keylist = collect(keys(arr[1]))
    for k in keylist
        typelist = [typeof(arr[i][k]) for i in 1:length(arr)]   # Allocation :(
        type_counts[k] = StatsBase.countmap(typelist)
    end
    return type_counts
end

"""
    countmapvalues(arr::AbstractArray, keyname::AbstractString)

Return a `Dict` of the values found for `keyname` and the number of times each appears.
"""
function countmapvalues(arr::AbstractArray, keyname::AbstractString)
    (length(arr) > 0 && haskey(arr[1], keyname)) || error("No key '$keyname'")
    return StatsBase.countmap([arr[i][keyname] for i in 1:length(arr)])
end



"""
    countmapnumvalues(arr::AbstractArray)

Assume `arr` is an array of `Associative` objects with identical keys. Return
a countmap of the number of distinct values associated with each key.
"""
countmapnumvalues(arr::AbstractArray) = countmapnumvalues(arr, typeof(arr[1]))

countmapnumvalues(arr::AbstractArray, dicttype) = dicttype( k => length(countmapvalues(arr, k)) for k in keys(arr[1]))

"""
    countmaptypenumvalues(arr::AbstractArray)

Returns a `Associative` object whos values for each key are a tuple of
the corresponding values returned by `countmaptypes` and `countmapnumvalues`.
"""
function countmaptypenumvalues(arr::AbstractArray)
    cn = countmapnumvalues(arr)
    ct = countmaptypes(arr)
    dicttype = typeof(arr[1])
    dicttype( k => (ct[k], cn[k]) for k in keys(arr[1]))
end


"""
    isapprox(l::Associative, r::Associative)

Returns true if `l` and `r` have approximately the same
keys and values.
"""
function Base.isapprox(l::Associative, r::Associative)
    l === r && return true
    if isa(l,ObjectIdDict) != isa(r,ObjectIdDict)
        return false
    end
    if length(l) != length(r) return false end
    for pair in l
        if !in(pair, r, isapprox)
            return false
        end
    end
    true
end

"""
    rgbtohex(r::Integer, g::Integer, b::Integer)

convert rgb color to hex format.
"""
rgbtohex(r::Integer, g::Integer, b::Integer) =  "#" * string( hex.( (r,g,b), 2 )...)

end # module UtilsGJL
