# Description
`loco` provides an efficient implementation of the Leave-One-Covariate-Out (LOCO) framework, a model-free, prediction-based approach to variable importance that measures how much predictive accuracy declines when each covariate is removed from a fitted model.

# Instruction for Installation
You can install the package using `devtools`.
``` r
devtools::install_github("statkwon/loco")
```

# How to Use
`loco` computes prediction intervals for the excess test error due to dropping a variable, measured in-sample and having valid in-sample coverage.
To get started, follow the example code below:
```r
library(loco)

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

out <- loco(X, y, train.fun, predict.fun, alpha = 0.1)

variable_importance_plot(X, y, out)
```

# TODOs
- [x] Implement R wrapper for the LOCO framework
- [x] Implement C++ backend for core LOCO computations
- [x] Add a 'How to Use' section to the README
- [x] Add references and citations for the LOCO framework
- [x] Write unit tests for the package functions
