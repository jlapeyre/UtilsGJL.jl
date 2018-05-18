"""
    truncfloat(x::Real, ndigits=3)

truncate all but the last `ndigits` digits to the
right of the decimal point in `x`.
"""
function truncfloat(x::Real, ndigits=3)
    xf = float(x)
    fac = 10^ndigits
    round(Int,xf*fac)/fac
end


"""
    merge1!(d::AbstractDict, others::AbstractArray{AbstractDict})

The same as `merge!`, except that `others` is an array of `AbstractDict`s.
This is far more efficient when the length of `others` is large.
"""
function merge1!(d::AbstractDict, others::AbstractArray{T}) where T <: AbstractDict
    for other in others
        for (k,v) in other
            d[k] = v
        end
    end
    return d
end

"""
    merge1(ds::AbstractArray)

Return a dictionary merging the `AbstractDict`s in `ds`.
`merge1` is like `merge`, but the dictionaries are passed
in an array, rather than separate parameters. This is much
more efficient for many dictionaries.
The output `AbstractDict` is of the same concrete type as
the first element of `ds`. All of the remaining dictionaries
must be compatible with this choice.
"""
function merge1(ds::AbstractArray{T}) where T <: AbstractDict
    t = eltype(ds)
    merge1!(t(),ds)
end


"""
    nonuniquecount(itr)

Return the number of nonunique values in `itr`.
This is no more efficient than `length(nonunique(itr))`.
"""
function nonuniquecount(a::AbstractArray{T}) where {T}
    d = Dict{T,Int}()
    nucount = 0
    for x in a
        if haskey(d,x)
            d[x] += 1
            if d[x] == 2
                nucount += 1
            end
        else
            d[x] = 1
        end
    end
    nucount
end


"""
    nonunique(itr)

Return an array containing one value from `itr` for each nonunique value.
"""
function nonunique(a::AbstractArray{T}) where {T}
    seen = Dict{T,Int}()
    out = Vector{T}()
    for x in a
        if haskey(seen,x)
            seen[x] += 1
            seen[x] == 2 && push!(out,x)
        else
            seen[x] = 1
        end
    end
    return out
end
# Above is faster than below, for at least some tests
# function nonunique(a::AbstractArray{T}) where {T}
#     d = DataStructures.counter(T)
#     nu = Vector{T}()
#     @inbounds for x in a
#         push!(d,x)
#         d[x] == 2 && push!(nu,x)
#     end
#     nu
# end


"""
    sortcountmap(itr; byvalue=true, rev=true)

Return a `countmap`, a dictionary mapping each unique value in `itr` to its number of occurrences,
sorted by count in decreasing order.

If `byvalue=false`, sorting is done by key. I don't expect the sort interface to stay
stable for long, so this function may break in various ways.
"""
function sortcountmap(arr; byvalue=true,rev=true)
    if byvalue
        sort(countmap(arr), byvalue=true, rev=rev)
    else
        sort(countmap(arr), rev=rev)  # we must omit byvalue. byvalue=false fails to order by key.
    end
end

"""
    foreachdict(f,itr::AbstractDict)

Equivalent to `foreachdict(f,keys(itr),values(itr))`.

# Example

```jldoctest
julia> d = Dict(:a=>1, :b=>2);

julia> foreachdict((k,v) -> println(k,v), d)
a1
b2
```
"""
foreachdict(f,itr::AbstractDict) = foreach(f,keys(itr),values(itr))


"""
    function foreachdict(f,itrs...)

Equivalent to `foreach(f,itrs...)`, except that each element `itr` of
`itrs` that is a subtype of `AbstractDict` is replaced with `keys(itr), values(itr)`.
"""
function foreachdict(f,itrs...)
    a = Any[]
    for itr in itrs
        if isa(itr,AbstractDict)
            push!(a,keys(itr))
            push!(a,values(itr))
        else
            push!(a,itr)
        end
    end
    foreach(f,a...)
end

foreachdict(f) = foreach(f)


"""
    equalelements(a,b)

Return `true` if `a` and `b` are element-wise equal, using `==`.
For arrays, this is equivalent to `a == b`. But, for some iterators
a method for `==` is not defined.

`equalelements` should give the same result as `collect(a) == collect(b)`,
but perhaps do it more efficiently as it avoids allocation.
This funciton may be unnecessary in v0.7.
"""
function equalelements(a,b)
    for (x,y) in zip(a,b)
        x != y && return false
    end
    return true
end

"""
    allkeysequal(a::AbstractArray)::Bool

Return `true` only if all elements of `a` have keys and the set of keys of the first element of `a` is identical
to the set of keys of each of the other elements.
"""
#function check_key_consistency(a::AbstractArray{AbstractDict}) #  AbstractArray{Any} also works here
function allkeysequal(a::AbstractArray)
    length(a) == 0 && return false
    len = length(a[1])
    all(x -> length(x) == len, a) || return false
    ks = keys(a[1])
    for (i,obj) in enumerate(a)
        equalelements(keys(obj),  ks)  || return false
    end
    return true
end

"""
    countmaptypes(arr::Array)

Return a count map of the types of elements in `arr`
"""
function countmaptypes(arr::Array)
    typelist = [typeof(x) for x in arr]
    StatsBase.countmap(typelist)
end

"""
    countmaptypes(arr::Array{T}) where T <: AbstractDict

Return a count map of the value types for each key in elements of `arr`.

`arr` is an array of objects of type `AbstractDict` with identical keys.
"""
function countmaptypes(arr::Array{T}) where T <: AbstractDict
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

Assume `arr` is an array of `AbstractDict` objects with identical keys. Return
a countmap of the number of distinct values associated with each key.
"""
countmapnumvalues(arr::AbstractArray) = countmapnumvalues(arr, typeof(arr[1]))

countmapnumvalues(arr::AbstractArray, dicttype) = dicttype( k => length(countmapvalues(arr, k)) for k in keys(arr[1]))

"""
    countmaptypenumvalues(arr::AbstractArray)

Return a `AbstractDict` object whos values for each key are a tuple of
the corresponding values returned by `countmaptypes` and `countmapnumvalues`.
"""
function countmaptypenumvalues(arr::AbstractArray)
    cn = countmapnumvalues(arr)
    ct = countmaptypes(arr)
    dicttype = typeof(arr[1])
    dicttype( k => (ct[k], cn[k]) for k in keys(arr[1]))
end


"""
    isapprox(l::AbstractDict, r::AbstractDict)

Return true if `l` and `r` have approximately the same
keys and values.
"""
function Base.isapprox(l::AbstractDict, r::AbstractDict)
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
