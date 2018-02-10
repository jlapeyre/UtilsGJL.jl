using Compat

foreachdict(f,itr::AbstractDict) = foreach(f,keys(itr),values(itr))

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

nothing


# foreach(f) = (f(); nothing)
# foreach(f, itr) = (for x in itr; f(x); end; nothing)
# foreach(f, itrs...) = (for z in zip(itrs...); f(z...); end; nothing)
