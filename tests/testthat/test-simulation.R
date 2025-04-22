test_that("count distribution simulation", {
  # Generate data
  set.seed(1)
  counts <- countDistr(1000, 10, sparsity = 0.9)

  # Check matrix shape
  expect_equal(nrow(counts), 1000)
  expect_equal(ncol(counts), 10)

  # Check values
  check <- c(2251, 2605, 2660, 2339, 2200, 2689, 2072, 2466, 2495, 2410)
  expect_equal(colSums(counts), check)

  # Check sparsity
  counts <- countDistr(100, 10, sparsity = 0.5)
  expect_equal(sum(counts == 0) / 1000, 0.5)
  counts <- countDistr(100, 10, sparsity = 0)
  expect_equal(sum(counts == 0) / 1000, 0)
  counts <- countDistr(100, 10, sparsity = 1)
  expect_equal(sum(counts == 0) / 1000, 1)
})

test_that("Count matrix simulation", {
  # Generate data
  set.seed(1)
  readCounts <- simReadCounts(
    100,
    100,
    sparsity = 0.75,
    monoDom = 0.025,
    lowQual = 0.1
  )

  # Check sample type counts
  sampleTypes <- sub("^([^_]+).*", "\\1", colnames(readCounts)) |>
    table() |>
    c()
  expect_equal(sampleTypes, c(lowQual = 10, monoDom = 3, sample = 87))

  # Check error
  expect_error(simReadCounts(100, 100, monoDom = 0.6, lowQual = 0.7))
})
