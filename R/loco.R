#' Leave-One-Covariate-Out
#'
#' This function implements the Leave-One-Covariate-Out (LOCO) conformal prediction intervals as described in Lei et al. (2018).
#' The LOCO method provides distribution-free predictive inference for regression models by constructing prediction intervals that
#' account for the uncertainty associated with leaving out each covariate in turn.
#'
#' @references Lei, J., G’Sell, M., Rinaldo, A., Tibshirani, R. J., & Wasserman, L. (2018).
#' Distribution-free predictive inference for regression. Journal of the American Statistical Association, 113(523), 1094-1111.
#'
#' @param X feature matrix \eqn{X} of dimension \eqn{n\times p}
#' @param y target vector \eqn{Y} of length \eqn{n}
#' @param train.fun a function to perform model training
#' @param predict.fun a function to perform prediction
#' @param alpha miscoverage level for the conformal prediction intervals (optional, default is 0.1)
#' @param seed random seed for data splitting (optional)
#'
#' @return conformal prediction intervals for
#' \eqn{\Delta_j(X_{n+1}, Y_{n+1})=\vert Y_{n+1}-\hat{\mu}_{(-j)}(X_{n+1})\vert-\vert Y_{n+1}-\hat{\mu}(X_{n+1})\vert}
#'
#' @examples
#' n <- 1000
#' p <- 6
#' X <- replicate(p, runif(n, -1, 1))
#' epsilon <- rnorm(n)
#' y <- sin(pi * (1 + X[, 1])) * (X[, 1] < 0) + sin(pi * X[, 2]) + sin(pi * (1 + X[, 3])) * (X[, 3] > 0) + epsilon
#'
#' train.fun <- function(X, y) {
#'   df <- data.frame(y, X)
#'   return(lm(y ~ ., data = df))
#' }
#'
#' predict.fun <- function(model, X) {
#'   df <- data.frame(X)
#'   return(predict(model, newdata = df))
#' }
#'
#' out <- loco(X, y, train.fun, predict.fun, alpha = 0.1)
#'
#' @export
loco <- function(X,
                 y,
                 train.fun,
                 predict.fun,
                 alpha = 0.1,
                 seed = NULL) {
  # Compatibility checks
  if (nrow(X) != length(y)) {
    stop("Number of rows in X must match length of y.")
  }
  if (alpha <= 0 || alpha >= 1) {
    stop("alpha must be between 0 and 1.")
  }

  if (is.null(seed)) {
    seed = -1
  }

  out = loco_c(X, y, train.fun, predict.fun, alpha, seed)

  return(out)
}
