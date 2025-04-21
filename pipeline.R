# Code Reproducibility in R - Single Cell RNA-seq example
# ///////////////////////////////////////////////////////

set.seed(1)
#Simulate a raw read count matrix
readCounts <- simReadCounts(20000, 250, doublet = 0.02, lowQual = 0.08)

# Check the distribution of the number of expressed genes per cell
genesExprPerCell <- (readCounts > 0) |> colSums()
genesExprPerCell |> hist()

# Remove low quality samples (<500 expressed genes)
highQual <- readCounts[, genesExprPerCell >= 500]
(highQual > 0) |> colSums() |> hist()

# Detect potential doublet cells (>2sd number of genes expressed)
genesExprPerCell <- (highQual > 0) |> colSums()
avgGexpr <- mean(genesExprPerCell)
sdGexpr <- sd(genesExprPerCell)

highQual <- highQual[, genesExprPerCell < avgGexpr + 2 * sdGexpr]
(highQual > 0) |> colSums() |> hist()
