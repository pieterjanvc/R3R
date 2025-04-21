test_that("count distribution simulation", {
  # Generate data
  set.seed(1)
  counts <- countDistr(1000, 10)

  # Check matrix shape
  expect_equal(nrow(counts), 1000)
  expect_equal(ncol(counts), 10)

  # Check values
  check <- c(657, 589, 610, 592, 552, 696, 555, 644, 655, 634)
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
  readCounts <- simReadCounts(100, 100, doublet = 0.025, lowQual = 0.1)

  # Check cell type counts
  cellTypes <- sub("^([^_]+).*", "\\1", colnames(readCounts)) |>
    table() |>
    c()
  expect_equal(cellTypes, c(cell = 87, doublet = 3, lowQual = 10))

  # Check error
  expect_error(simReadCounts(100, 100, doublet = 0.6, lowQual = 0.7))
})
