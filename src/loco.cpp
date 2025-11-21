#include <RcppArmadillo.h>

using namespace Rcpp;

// [[Rcpp::export]]
arma::mat loco_c(const arma::mat& X, const arma::vec& y, Function mean_fun, Function predict_fun, int n_train) {
  int n = X.n_rows;
  int p = X.n_cols;
  arma::mat Delta(n - n_train, p);
  return Delta;
}
