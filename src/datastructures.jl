"""
    writeloghist(fname,data;opts...)

Write a log-scaled histogram to a the file `fname`.
"""
function writeloghist(fname,data;opts...)
    x,y = loghistogram(data;opts...)
    x1 = truncfloat.(x,1)
    writedlm(fname,zip(x1,y)," ")
end


"""
    loghistogram(data;opts...)

Returns a tuple, the coordinate and the ordinates for a log scale
histogram. `opts...` are passed to `fit(Histogram,...`.
The output `res` can be written to a file with `writedlm("f.txt",zip(res...))`.
This function is in lieu of a proper log-scaled histogram.
"""
function loghistogram(data;opts...)
    hist = fit(Histogram,log.(data); opts..., closed=:left)
    collect(exp.((hist.edges)[1])), hist.weights
end


"""
    append(a::Vector)::Vector

Flatten a vector of vectors, all of the same
eltype.
"""
# Don't restrict the input type, so we can use iterators.
function append(a)::Vector
    tp = eltype(a[1])
    vout = tp[]
    for x in a
        for y in x
            push!(vout,y)
        end
    end
    vout
end

"""
    arrcountmap(a1::Vector, a2::Vector{T}) where T<:Integer

Sum the counts in each element of `a2` for each occurrence of an item
in all of the elements of `a1`. Return a countmap of these sums for each of the
unique elements in the arrays in `a1`.

Example:
```julia
julia> d = Dict( ["a","b"] => 1, ["b", "c"] => 2 );

julia> arrcountmap(keys(d), values(d))
DataStructures.Accumulator{String,Int64} with 3 entries:
  "c" => 2
  "b" => 3
  "a" => 1
```
"""
# This allows iterators for `a1` and `a2` to be used
function arrcountmap(a1, a2)::DataStructures.Accumulator
    acc = counter(a1 |> eltype |> eltype)
    for (teams,nclicks) in zip(a1,a2)
        for team in teams
            push!(acc,team,nclicks)
        end
    end
    acc
end

"""
    arrcountmap(d::AbstractDict)

Pass the keys and values of `d` as the two arrays to `arrcountmap`.
"""
arrcountmap(d::AbstractDict) = arrcountmap(keys(d),values(d))

# Catches errors, but prevents iterators from working
# function arrcountmap(a1::Vector, a2::Vector{T})::DataStructures.Accumulator where T<:Integer
#     acc = counter(a1 |> eltype |> eltype)
#     for (teams,nclicks) in zip(a1,a2)
#         for team in teams
#             push!(acc,team,nclicks)
#         end
#     end
#     acc
# end


"""
    subst!(arr,from,to)::Void

Substitute each occurrence of `from` in the values of collection `arr` with `to`.
"""
function subst!(arr,from,to)::Void
    for i in linearindices(arr)
    @inbounds  if arr[i] == from
            arr[i] = to
        end
    end
end

"""
    subst!(d::AbstractDict,from,to)::Void

Substitute each occurrence of `from` in the values of `d` with `to`.
"""
function subst!(d::AbstractDict,from,to)::Void
    for (k,v) in d
         if d[k] == from
            d[k] = to
        end
    end
end


"""
    keepkeys(dict::AbstractDict, keylist::AbstractArray)

Return a copy of `dict` keeping only keys in `keylist`.
It makes sense to broadcast over the first argument more than
it does the second, but this does not work at the moment.
"""
keepkeys(dict::AbstractDict, keylist::AbstractArray) = keepkeys(dict,typeof(dict),keylist)

"""
    keepkeys(dict::AbstractDict, keylist::AbstractArray, T::DataType)

Specify the the type `T` of the returned dictionary.
"""
keepkeys(dict::AbstractDict, keylist::AbstractArray, T::DataType) = T(k => dict[k] for k in keylist)

"""
    arraytodict(arr::AbstractArray, pkey; dicttype=Dict)

Construct a dictionary of arrays from the array of dictionaries `arr`.
The keys of the output dictionary are the values correpsonding to
the key `pkey` in each dictionary in `arr`. Each value in the
output dictionary is an array of dictionaries
each with the same value for key `pkey`.

This function could use a better name.
"""
function arraytodict(arr::AbstractArray, pkey; dicttype=Dict)
    kt = typeof(arr[1][pkey])
    dout = dicttype{kt,Any}() # could make this more specific
    for obj in arr
        nkey = obj[pkey]
        haskey(dout,nkey) ? nothing : dout[nkey] = Any[]
        push!(dout[nkey],obj)
    end
    return dout
end

"""
    fields(x)

Unpack the fields in struct `x` into a `Tuple`.
"""
fields(x) = ((getfield(x, field) for field in fieldnames(typeof(x)))...,)
