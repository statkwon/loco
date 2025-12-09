#' Variable Importance Plot
#'
#' This function generates variable importance plots based on the output from the \code{loco} function.
#'
#' @param X feature matrix \eqn{X} of dimension \eqn{n\times p}
#' @param y target vector \eqn{Y} of length \eqn{n}
#' @param out output from the \code{loco} function
#'
#' @export
variable_importance_plot <- function(X, y, out) {
  # Compatibility checks
  if (nrow(X) != length(y)) {
    stop("Number of rows in X must match length of y.")
  }
  if (!all(c("lb", "ub") %in% names(out))) {
    stop("'out' must be a list containing both 'lb' and 'ub'.")
  }
  if (!all(dim(out$lb) == dim(X)) ||
      !all(dim(out$ub) == dim(X))) {
    stop("'lb' and 'ub' in 'out' must have the same dimensions as 'X'.")
  }

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
