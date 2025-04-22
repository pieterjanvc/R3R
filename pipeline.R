# /// Microbiome Taxa Detection ///
# /////////////////////////////////

#Simulate a raw read count matrix
set.seed(10)
readCounts <- simReadCounts(
  nTaxa = 1500,
  nSamples = 100,
  sparsity = 0.75,
  monoDom = 0.02,
  lowQual = 0.08
)

# Check the distribution of the number of expressed taxa per sample
colSums(readCounts > 0) |> hist(main = "Taxa per sample")

# Remove low quality samples (<25 reads for best taxon)
lowQual <- apply(readCounts, 2, function(x) {
  max(x) < 25
})

readCounts <- readCounts[, !lowQual]
colSums(readCounts > 0) |> hist(main = "Taxa per sample")

# Detect potential monodominant samples (1 species dominating the rest)
monodominant <- apply(readCounts, 2, function(x) {
  x = x[x > 0]
  any(x > mean(x) + 5 * sd(x))
})

readCounts <- readCounts[, !monodominant]
colSums(readCounts > 0) |> hist(main = "Taxa per sample")
