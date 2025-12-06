#include <RcppArmadillo.h>

using namespace Rcpp;

List roo_split_cp(const arma::mat& X, const arma::vec& y, Function train_fun,
                  Function predict_fun, double alpha,
                  const std::vector<arma::uvec>& I) {
  int n = X.n_rows;

  arma::vec y_pred(n), lb(n), ub(n);

  for (int k = 0; k < 2; k++) {
    arma::mat X_train = X.rows(I[k]);
    arma::vec y_train = y(I[k]);
    arma::mat X_cal = X.rows(I[1 - k]);
    arma::vec y_cal = y(I[1 - k]);

    auto model = train_fun(X_train, y_train);
    y_pred(I[1 - k]) = as<arma::vec>(predict_fun(model, X_cal));
    arma::vec res = arma::abs(y_cal - y_pred(I[1 - k]));

    for (int i = 0; i < I[1 - k].n_elem; i++) {
      arma::vec res_j = res;
      res_j.shed_row(i);
      arma::vec sorted_res_j = arma::sort(res_j);
      double q = sorted_res_j(std::ceil(I[1 - k].n_elem * (1 - alpha)));
      lb(I[1 - k][i]) = y_pred(I[1 - k][i]) - q;
      ub(I[1 - k][i]) = y_pred(I[1 - k][i]) + q;
    }
  }

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
