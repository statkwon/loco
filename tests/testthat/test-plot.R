test_that("Tests for plot.R", {
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

  out <- loco(X, y, train.fun, predict.fun)

  # Test if variable_importance_plot() runs without error
  expect_no_error(variable_importance_plot(X, y, out))

  # Test if compatibility checks work
  out_without_lb <- out
  out_without_lb$lb <- NULL
  expect_error(
    variable_importance_plot(X, y, out_without_lb),
    "'out' must be a list containing both 'lb' and 'ub'."
  )

  out_without_ub <- out
  out_without_ub$ub <- NULL
  expect_error(
    variable_importance_plot(X, y, out_without_ub),
    "'out' must be a list containing both 'lb' and 'ub'."
  )

  out_wrong_dim_lb <- out
  out_wrong_dim_lb$lb <- matrix(0, nrow = n + 1, ncol = p)
  expect_error(
    variable_importance_plot(X, y, out_wrong_dim_lb),
    "'lb' and 'ub' in 'out' must have the same dimensions as 'X'."
  )

  out_wrong_dim_ub <- out
  out_wrong_dim_ub$ub <- matrix(0, nrow = n, ncol = p + 1)
  expect_error(
    variable_importance_plot(X, y, out_wrong_dim_ub),
    "'lb' and 'ub' in 'out' must have the same dimensions as 'X'."
  )
})
