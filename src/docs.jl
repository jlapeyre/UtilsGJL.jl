## Source: Dan Getz https://stackoverflow.com/questions/44166177/julia-list-docstrings-inside-a-module

# Note: `isdefined` here is a workaround for a bug
# check if a symbol is a nested module
issubmodule(m::Module, s::Symbol) = isdefined(m,s) && isa(eval(m,s),Module) && module_name(m) != s

# get a list of all submodules of module m
submodules(m) = filter(x->issubmodule(m,x),names(m,true))

# get a list of all docstring bindings in a module
allbindings(m) = [ [y[2].data[:binding] for y in x[2].docs]
  for x in eval(m,Base.Docs.META)]

# recursively get all docstrings from a module and submodules
function getalldocs(m)
    thedocs = map(x->Base.Docs.doc(x[1]),allbindings(m))
    return vcat(thedocs,map(x->alldocs(eval(m,x)),submodules(m))...)
end

# Note: this test for Nothing is a workaround for a bug
function _findtypes(docs,thetype::DataType)
    inds = find(x -> !isa(x, Nothing) && isa(eval(docs[1].meta[:binding].mod, x.meta[:binding].var), thetype) , docs)
    return inds
end

printcategory(items) = foreach( x -> (display(x), print_with_color(:bold, "\n" * "-"^40 * "\n\n")), items)

"""
    alldocs(amodule)

Display all the docstrings in module `amodule`.
This is not perfect.
"""
function alldocs(amodule)
    docs = reverse!(getalldocs(amodule))
    allinds = collect(1:length(docs))
    indsmodules = _findtypes(docs,Module)
    indsfunctions0 = _findtypes(docs,Function)
    indstypes = _findtypes(docs,DataType)
    indsfunctions = setdiff(indsfunctions0, indstypes) # Constructors of types are together with types
    indsvars = setdiff(allinds,vcat(indsmodules,indsfunctions,indstypes))

    (modules,types,functions,data) = ([docs[x] for x in (indsmodules, indstypes, indsfunctions, indsvars)]...,)

    print_with_color(:bold, "MODULE ")
    print_with_color(:bold, modules[1].meta[:binding], "\n\n")
    printcategory(modules)
    print_with_color(:bold, "\nTYPES\n\n")
    printcategory(types)
    print_with_color(:bold, "\nFUNCTIONS\n\n")
    printcategory(functions)
    print_with_color(:bold, "\nDATA\n\n")
    printcategory(data)
end
