# Description
`loco` provides an efficient implementation of the Leave-One-Covariate-Out (LOCO) framework, a model-free, prediction-based approach to variable importance that measures how much predictive accuracy declines when each covariate is removed from a fitted model.

# Instruction for Installation
You can install the package using `devtools`.
``` r
devtools::install_github("statkwon/loco")
```

# TODOs
- [ ] Implement R wrapper for the LOCO framework
- [ ] Implement C++ backend for core LOCO computations
- [ ] Add a 'How to Use' section to the README
- [ ] Add references and citations for the LOCO framework
- [ ] Write unit tests for the package functions
