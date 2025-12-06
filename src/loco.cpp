#include <RcppArmadillo.h>

using namespace Rcpp;

List roo_split_cp(const arma::mat& X, const arma::vec& y, Function train_fun,
                  Function predict_fun, double alpha,
                  const std::vector<arma::uvec>& I) {
  int n = X.n_rows;

  arma::vec y_pred(n);
  arma::vec lb(n);
  arma::vec ub(n);

  return List::create(Named("y_pred") = y_pred, Named("lb") = lb,
                      Named("ub") = ub);
}

// [[Rcpp::export]]
List loco_c(const arma::mat& X, const arma::vec& y, Function train_fun,
            Function predict_fun, double alpha, int seed) {
  int n = X.n_rows;
  int p = X.n_cols;

  arma::mat lb(n, p);
  arma::mat ub(n, p);

  return List::create(Named("lb") = lb, Named("ub") = ub);
}
