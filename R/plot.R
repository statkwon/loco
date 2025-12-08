#' Variable Importance Plot
#'
#' @param X feature matrix \eqn{X} of dimension \eqn{n\times p}
#' @param out output from the \code{loco} function
#'
#' @export
variable_importance_plot <- function(X, out) {
  n <- nrow(X)
  p <- ncol(X)

  par(mfrow = c(ceiling(p / 3), 3))
  for (j in 1:p) {
    plot(
      X[, j],
      y,
      type = 'n',
      xlab = "Location",
      ylab = "Interval",
      main = paste("Component", j)
    )
    for (i in 1:n) {
      if (out$lb[i, j] > 0) {
        segments(X[i, j], out$lb[i, j], X[i, j], out$ub[i, j], col = "green")
      } else {
        segments(X[i, j], out$lb[i, j], X[i, j], out$ub[i, j], col = "black")
      }
    }
    abline(h = 0,
           lty = 2,
           col = "red")
  }
}
