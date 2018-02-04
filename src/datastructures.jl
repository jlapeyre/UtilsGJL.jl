"""
    arraytodict(arr, pkey; dicttype=Dict)

Construct a Dict of Arrays from the array of Dicts `arr`,
by collecting in Arrays the elements `e` of `arr` by the value of `e[pkey]`.
The keys of the output Dict is the set of unique values of `e[pkey]`.

This function could use a better name.
"""
function arraytodict(arr, pkey; dicttype=Dict)
    kt = typeof(arr[1][pkey])
    d = dicttype{kt,Any}() # could make this more specific
    for obj in arr
        nkey = obj[pkey]
        if ! haskey(d,nkey)
            d[nkey] = Any[]
        end
        push!(d[nkey],obj)
    end
    d
end

