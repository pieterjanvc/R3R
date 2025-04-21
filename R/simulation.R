# Create an count matrix based on number of genes, cells and sparsity
countDistr <- function(nGenes, nCells, sparsity = 0.9) {
  n <- nGenes * nCells
  countMat <- matrix(0, nrow = nGenes, ncol = nCells)
  countMat[sample(1:n, n * (1 - sparsity))] <-
    rpois(n * (1 - sparsity), rlnorm(100, 1.5, 0.5)) + 1
  return(countMat)
}

#' Simulate a very simple raw scRNA-seq expression matrix for testing
#'
#' @param nGenes The number of genes (rows) in the matrix
#' @param nCells The number of cells (columns) in the matrix
#' @param sparsity Default = 0.9. The sparsity of the matrix (percentage of 0's)
#' @param doublet Default = 0. The percentage of doublets
#' @param lowQual Default = 0. The percentage of low quality cells
#'
#' @import glue
#'
#' @return genes by cell matrix with ransom read counts
#'
simReadCounts <- function(
    nGenes, nCells, sparsity = 0.9,
    doublet = 0, lowQual = 0) {
  if (doublet + lowQual > 1) {
    stop("The combined percentages of doublet and lowQual must be <= 1")
  }

  # Calculate number each type of  cell
  nDoublets <- ceiling(nCells * doublet)
  nLowQual <- ceiling(nCells * lowQual)
  nNormal <- nCells - (nDoublets + nLowQual)

  # Generate counts for the normal cells
  readCounts <- countDistr(nGenes, nNormal, sparsity)
  colnames(readCounts) <- glue("cell_{1:ncol(readCounts)}")

  # Simulate doublets by adding another expression pattern
  if (nDoublets > 0) {
    doubletCells <- countDistr(nGenes, nDoublets, sparsity) +
      countDistr(nGenes, nDoublets, sparsity)
    colnames(doubletCells) <- glue("doublet_{1:ncol(doubletCells)}")
    readCounts <- cbind(readCounts, doubletCells)
  }

  # Simulate doublets by adding another expression pattern
  if (nLowQual > 0) {
    lowSparsity <- sparsity + (1 - sparsity) * 0.9
    lowQualCells <- countDistr(nGenes, nLowQual, lowSparsity)
    colnames(lowQualCells) <- glue("lowQual_{1:ncol(lowQualCells)}")
    readCounts <- cbind(readCounts, lowQualCells)
  }

  return(readCounts)
}
