#' Leave-One-Covariate-Out
#'
#' @param X feature matrix \eqn{X} of dimension \eqn{n\times p}
#' @param y target vector \eqn{Y} of length \eqn{n}
#' @param train.fun a function to perform model training
#' @param predict.fun a function to perform prediction
#' @param alpha miscoverage level for the conformal prediction intervals (optional, default is 0.1)
#' @param seed random seed for data splitting (optional)
#'
#' @return importance matrix \eqn{\Delta} of dimension \eqn{n\times p}
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
