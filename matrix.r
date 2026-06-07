generate_sparse <- function(dim, density) {
  m <- Matrix::Matrix(0, nrow=dim, ncol=dim, sparse=TRUE)
  coords <- which(matrix(runif(dim*dim), dim, dim) < density, arr.ind=TRUE)
  m[coords] <- rnorm(nrow(coords), mean=0, sd=1/dim)
  return(m)
}

extract_eigen <- function(mat, k) {
  eigs <- Matrix::eigs(mat, k=k, which="LM")
  v <- eigs$values
  Re(v[!is.na(v)])
}

obfuscate_space <- function(dim=1024, density=0.01, k=5) {
  sp <- generate_sparse(dim, density)
  extract_eigen(sp, k)
}