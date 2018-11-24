# module StringsGJL

export readbytes, readlinebytes, filter_non_ascii, count_non_ascii, countsubstrings,
    compactstring

"""
    compactstring(d::AbstractDict)

Return a compact string representation of `d`.

Example:
```
compactstring(Dict(Void=>46,Float64=>21,Int64=>18))
"Void:46,Float64:21,Int64:18"
```
"""
compactstring(d::AbstractDict) = join([string(x[1] , ":", x[2]) for x in d], ",")

"""
    compactstring(::Array{String})

Return a compact string representation of `a`.
This just joins the strings with a comma.
"""
compactstring(a::Array{T}) where T <: AbstractString = join(a,",")


"""
    readbytes(filename::AbstractString, numbytes=0)

Read the contents of `filename`, but return a byte array, rather than a
string. If numbytes is greater than `0` return at most `numbytes` bytes.
Otherwise, read the entire file.
"""
function readbytes(filename::AbstractString, numbytes::Integer=0)
    numbytes = numbytes > 0 ? numbytes : filesize(filename)
    open(filename) do io
        read(io,numbytes) # something broken. read doc does not agree with methods
    end
end


"""
    readlinebytes(stream::IO=STDIN; chomp::Bool=false)

Warning: If `chomp` is true, an error may be raised. For instance
on reading the first (but not subsequent) lines from a file.
Read an array of bytes terminated by '\n' from `stream`.  Lines in the
input end with '\n' or "\r\n" or the end of an input stream. When
`chomp` is true, these trailing newline characters are removed from the
line before it is returned. When `chomp` is false, they are returned as
part of the line.
"""
function readlinebytes(s::IO=STDIN; chomp::Bool=false)
    line = readuntil(s, 0x0a)
    i = length(line)
    if !chomp || i == 0 || line[i] != 0x0a
        return line
    elseif i < 2 || line[i-1] != 0x0d
        return resize!(line,i-1)
    else
        return resize!(line,i-2)
    end
end

"""
    filter_non_ascii(s)

return array of non-ascii characters in string `s::String`, or non-ascii bytes in `s::Array`.
"""
filter_non_ascii(s::AbstractString) = convert(Array{Char,1}, filter(c -> ! isascii(c), s))
filter_non_ascii(a::AbstractArray) = filter(c -> ! isascii(Char(c)), a)

"""
    count_non_ascii(s)

count number of non-ascii characters in string `s::String`, or non-ascii bytes in `s::Array`.
"""
count_non_ascii(str::AbstractString) =  count(c -> ! isascii(c), str)
count_non_ascii(a::AbstractArray) =  count(c -> ! isascii(Char(c)), a)

"""
    countsubstrings(where::String, what::String)

Count the number of occurrences of `what` in `where`. This
is copied from discourse or stackexchange.
"""
function countsubstrings(where::String, what::String)
    numfinds = 0
    starting = 1
    while true
        location = search(where, what, starting)
        isempty(location) && return numfinds
        numfinds += 1
        starting = location.stop + 1
    end
end

"""
    countsubstrings(where::String, what::String)

Count the number of occurrences of `what` in `where`. This
is copied from discourse or stackexchange.
"""
function allstringmatch(where::String, what)
    numfinds = 0
    starting = 1
    res = String[]
    while true
        location = search(where, what, starting)
        isempty(location) && return break
        push!(res,where[location])
        numfinds += 1
        starting = location.stop + 1
    end
    return res
end

# end # module
