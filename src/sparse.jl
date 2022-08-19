"""
    transposeconc(M)

Return the concrete transpose of the sparse matrix `M`. That is, do
not return `M` wrapped in `Transpose`, but rather a new sparse matrix.
"""
function transposeconc(M)
    I1,J,V = findnz(M)
    m,n = size(M)
    return sparse(J,I1,V,n,m)
end
