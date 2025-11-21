#' Leave-One-Covariate-Out
#'
#' @param X feature matrix \eqn{X} of dimension \eqn{n\times p}
#' @param y target vector \eqn{Y} of length \eqn{n}
#' @param mean.fun mean function \eqn{\hat{\mu}} fitted with \eqn{X} and \eqn{y}
#' @param refitted.fun mean function \eqn{\hat{\mu}_{(-j)}} to refit with \eqn{X(-j)} and \eqn{y}
#'
#' @return prediction interval matrix \eqn{W} of size \eqn{n\times p}
#' @export
loco <- function(X, y, mean.fun, refitted.fun) {
  W = NULL
  return(W)
}
