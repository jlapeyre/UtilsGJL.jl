# module StringsGJL

export readbytes, readlinebytes, filter_non_ascii, count_non_ascii, countsubstrings
 
# Julia core file reading is in flux and not well documented.
# most of this stuff is not necessary.

# function readbytes(filename::AbstractString)
#     numbytes = filesize(filename)
#     b = Array{UInt8,1}()
#     open(f -> readbytes!(f, b, numbytes), filename)
#     return b
# end

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
    isascii(a::AbstractArray{UInt8})

returns `true` if all bytes in `a` are valid ASCII codes.
"""
Base.isascii(a::AbstractArray{UInt8}) = all(c -> isascii(Char(c)), a)


"""
    isascii(c::UInt8)

returns `true` if `c` is a valid ASCII code.
"""
Base.isascii(c::UInt8) = Char(c) |> isascii


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


# end # module