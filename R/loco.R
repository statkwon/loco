#' Leave-One-Covariate-Out
#'
#' @param X feature matrix \eqn{X} of dimension \eqn{n\times p}
#' @param y target vector \eqn{Y} of length \eqn{n}
#' @param mean.fun mean function \eqn{\hat{\mu}}
#' @param n.train \eqn{n_\text{train}} rows of \eqn{X} are randomly chosen and used to fit \eqn{\hat{\mu}},
#' another \eqn{n_\text{cal}=n-n_\text{train}} rows are used as a calibration set
#'
#' @return array of \eqn{p} matrices with conformal prediction intervals, \eqn{W_1, \ldots, W_p}, of size \eqn{n_\text{train}\times2}
#' @export
loco <- function(X, y, mean.fun, n.train) {
  W = array(dim = c(p, n.train, 2))
  return(W)
}
