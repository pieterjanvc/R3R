# Create an count matrix based on number of taxa, samples and sparsity
countDistr <- function(nTaxa, nSamples, sparsity, meanlog = 3) {
  n <- nTaxa * nSamples
  countMat <- matrix(0, nrow = nTaxa, ncol = nSamples)
  countMat[sample(1:n, n * (1 - sparsity))] <-
    rpois(n * (1 - sparsity), rlnorm(100, meanlog, 0.5)) + 1
  return(countMat)
}

#' Simulate a very simple metagenomic taxa count matrix for testing purposes
#'
#' @param nTaxa The number of taxa (rows) in the matrix
#' @param nSamples The number of samples (columns) in the matrix
#' @param sparsity Default = 0.9. The sparsity of the matrix (percentage of 0's)
#' @param monoDom Default = 0. The percentage of samples with monoDom
#' @param lowQual Default = 0. The percentage of low quality samples
#'
#' @import glue
#'
#' @return taxa by sample matrix with random read counts
#'
simReadCounts <- function(
  nTaxa,
  nSamples,
  sparsity,
  monoDom = 0,
  lowQual = 0
) {
  if (monoDom + lowQual > 1) {
    stop("The combined percentages of monoDom and lowQual must be <= 1")
  }

  # Calculate number each type of  sample
  nContaminated <- ceiling(nSamples * monoDom)
  nLowQual <- ceiling(nSamples * lowQual)
  nNormal <- nSamples - (nContaminated + nLowQual)

  # Generate counts for the normal samples
  readCounts <- countDistr(nTaxa, nNormal, sparsity)
  colnames(readCounts) <- glue("sample_{1:ncol(readCounts)}")

  # Simulate monodominance by having one very highly present species
  if (nContaminated > 0) {
    monoDomSamples <- countDistr(
      nTaxa,
      nContaminated,
      sparsity = 0.9,
      meanlog = 0.7
    )
    monoDomSamples[
      sample(1:nTaxa, nContaminated) + 0:(nContaminated - 1) * nTaxa
    ] =
      rnorm(nContaminated, sum(readCounts) / nNormal) |> ceiling()
    colnames(monoDomSamples) <- glue(
      "monoDom_{1:ncol(monoDomSamples)}"
    )
    readCounts <- cbind(readCounts, monoDomSamples)
  }

  # Simulate monoDom by adding another distribution pattern
  if (nLowQual > 0) {
    lowSparsity <- sparsity + (1 - sparsity) * runif(1, 0.75, 0.9)
    lowQualSamples <- countDistr(nTaxa, nLowQual, lowSparsity, meanlog = 1)
    colnames(lowQualSamples) <- glue("lowQual_{1:ncol(lowQualSamples)}")
    readCounts <- cbind(readCounts, lowQualSamples)
  }

  return(readCounts)
}
