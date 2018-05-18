"""
    longdisplay(x,rows=1000,mimetype="text/plain")
    ld(args...)

Display `x` with `rows` overriding the number of rows of the display.
This can be used to display all the rows of a `DataFrame` instance,
nicely formatted, at the REPL. It does not work for arrays.
"""
longdisplay(x,rows=1000,mimetype="text/plain") = longdisplay(STDOUT,x,rows,mimetype)

"""
    longdisplay(io::IO, x,rows=1000,mimetype="text/plain")

Send output to `io` instead of `STDOUT`.
"""
function longdisplay(io::IO, x, rows=1000, mimetype="text/plain")
    dispsize = displaysize()
    newdispsize = (rows,dispsize[2])
    show(IOContext(io, displaysize=newdispsize), mimetype, x)
end

const ld = longdisplay

"""
    @withw f(filename,x,y,...)

Open file `filename` for writing and call `f(io,x,y,...)` where
`io` is the output stream. The stream is closed when the call to `f`
exits.

# Example
julia> @withw println("outfile.txt", "hello")
"""
macro withw(fcall)
    (fn,fcall.args[2]) = (fcall.args[2],:io)
    quote
        open($fn,"w") do io
            $(fcall)
        end
    end
end
