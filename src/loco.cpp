#include <RcppArmadillo.h>

using namespace Rcpp;

// [[Rcpp::export]]
arma::cube loco_c(const arma::mat& X, const arma::vec& y, Function mean_fun, int n_train) {
  int p = X.n_cols;
  arma::cube W(p, n_train, 2);
  return W;
}
