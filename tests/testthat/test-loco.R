test_that("Tests for loco.R", {
  # Generate mocking data
  set.seed(0)

  n <- 1000
  p <- 6
  X <- replicate(p, runif(n, -1, 1))
  epsilon <- rnorm(n)

  y <- sin(pi * (1 + X[, 1])) * (X[, 1] < 0) + sin(pi * X[, 2]) + sin(pi * (1 + X[, 3])) * (X[, 3] > 0) + epsilon

  mean.fun <- function(X, y) {
    return(lm(y ~ X))
  }

  n.train <- 700

  # Test if loco() runs without error
  expect_no_error(loco(X, y, mean.fun, n.train))

  # Test if loco() returns an array of correct dimensions
  expect_equal(dim(loco(X, y, mean.fun, n.train)), c(n - n.train, p))

  # Test if compatibility checks work
  expect_error(loco(X[1:500, ], y, mean.fun, n.train),
               "Number of rows in X must match length of y.")
  expect_error(
    loco(X, y, mean.fun, n + 1),
    "n.train must be between 1 and n-1, where n is the number of rows in X."
  )
  expect_error(
    loco(X, y, mean.fun, 0),
    "n.train must be between 1 and n-1, where n is the number of rows in X."
  )
})
