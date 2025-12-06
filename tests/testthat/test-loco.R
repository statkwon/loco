test_that("Tests for loco.R", {
  # Generate mocking data
  set.seed(0)

  n <- 1000
  p <- 6
  X <- replicate(p, runif(n, -1, 1))
  epsilon <- rnorm(n)

  y <- sin(pi * (1 + X[, 1])) * (X[, 1] < 0) + sin(pi * X[, 2]) + sin(pi * (1 + X[, 3])) * (X[, 3] > 0) + epsilon

  train.fun <- function(X, y) {
    df <- data.frame(y, X)
    return(lm(y ~ ., data = df))
  }

  predict.fun <- function(model, X) {
    df <- data.frame(X)
    return(predict(model, newdata = df))
  }

  # Test if loco() runs without error
  expect_no_error(loco(X, y, train.fun, predict.fun))

  # Test if loco() returns an array of correct dimensions
  expect_equal(dim(loco(X, y, train.fun, predict.fun)$lb), dim(X))

  # Test if compatibility checks work
  expect_error(loco(X[1:500, ], y, train.fun, predict.fun),
               "Number of rows in X must match length of y.")
})
