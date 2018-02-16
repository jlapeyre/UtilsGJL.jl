## Source: Dan Getz https://stackoverflow.com/questions/44166177/julia-list-docstrings-inside-a-module

# check if a symbol is a nested module
issubmodule(m::Module, s::Symbol) = isa(eval(m,s),Module) && module_name(m) != s

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

function _findtypes(docs,thetype::DataType)
    inds = find(x->isa(eval(docs[1].meta[:binding].mod,x.meta[:binding].var),thetype),docs)
    return(docs[inds], inds)
end 

printcategory(items) = foreach( x -> (display(x), print_with_color(:bold, "\n" * "-"^40 * "\n\n")), items)

"""
    alldocs(amodule)

Display all the docstrings in module `amodule`.
"""
function alldocs(amodule)
    docs = getalldocs(amodule)
    allinds = collect(1:length(docs))
    (modules, inds1) = _findtypes(docs,Module)
    (functions,inds2) = _findtypes(docs,Function)
    (types,inds3) = _findtypes(docs,DataType)
    varinds = setdiff(allinds,vcat(inds1,inds2,inds3))
    data = docs[varinds]
    print_with_color(:bold, "MODULES\n\n")
    printcategory(modules)
    print_with_color(:bold, "\nTYPES\n\n")
    printcategory(types)
    print_with_color(:bold, "\nFUNCTIONS\n\n")
    printcategory(functions)
    print_with_color(:bold, "\nDATA\n\n")
    printcategory(data)    
end

