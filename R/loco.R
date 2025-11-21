#' Leave-One-Covariate-Out
#'
#' @param X feature matrix \eqn{X} of dimension \eqn{n\times p}
#' @param y target vector \eqn{Y} of length \eqn{n}
#' @param mean.fun mean function \eqn{\hat{\mu}}
#' @param n.train \eqn{n_\text{train}} rows of \eqn{X} are randomly chosen and used to fit \eqn{\hat{\mu}},
#' another \eqn{n_\text{cal}=n-n_\text{train}} rows are used as a calibration set
#'
#' @return importance matrix \eqn{\Delta} of dimension \eqn{n_\text{cal}\times p}
#' @export
loco <- function(X, y, mean.fun, n.train) {
  # Compatibility checks
  if (nrow(X) != length(y)) {
    stop("Number of rows in X must match length of y.")
  }
  if (n.train >= nrow(X) || n.train <= 0) {
    stop("n.train must be between 1 and n-1, where n is the number of rows in X.")
  }

  Delta = loco_c(X, y, mean.fun, n.train)
  return(Delta)
}
