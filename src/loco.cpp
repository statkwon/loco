#include <RcppArmadillo.h>

#include <algorithm>

using namespace Rcpp;

List roo_split_cp(const arma::mat& X, const arma::vec& y, Function train_fun,
                  Function predict_fun, double alpha,
                  const std::vector<arma::uvec>& I) {
  int n = X.n_rows;

  arma::vec y_pred(n), lb(n), ub(n);

  for (int k = 0; k < 2; k++) {
    arma::mat X_train = X.rows(I[k]);
    arma::mat X_cal = X.rows(I[1 - k]);
    arma::vec y_train = y(I[k]);
    arma::vec y_cal = y(I[1 - k]);

    // Train model with I[k] and compute residuals on I[1 - k]
    auto model = train_fun(X_train, y_train);
    y_pred(I[1 - k]) = as<arma::vec>(predict_fun(model, X_cal));
    arma::vec res = y_cal - y_pred(I[1 - k]);

    // Compute rank-one-out conformal prediction intervals
    arma::uvec sorted_indices = arma::sort_index(res);
    arma::uvec original_indices = arma::sort_index(sorted_indices);
    arma::vec sorted_res = arma::sort(res);
    for (int i = 0; i < I[1 - k].n_elem; i++) {
      // Remove the i-th residual
      arma::vec sorted_res_i = sorted_res;
      sorted_res_i.shed_row(original_indices(i));
      // Compute the quantile
      double q = sorted_res_i(std::ceil(I[1 - k].n_elem * (1 - alpha)));
      // Compute the prediction intervals
      lb(I[1 - k](i)) = y_pred(I[1 - k](i)) - q;
      ub(I[1 - k](i)) = y_pred(I[1 - k](i)) + q;
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

  arma::mat lb(n, p), ub(n, p);

  // Randomly split the data into two equal-sized subsets
  if (seed >= 0) {
    arma::arma_rng::set_seed(seed);
  }
  std::vector<arma::uvec> I(2);
  I[0] = arma::randperm(n, n / 2);
  I[1] = arma::regspace<arma::uvec>(0, n - 1);
  I[1].shed_rows(I[0]);

  // Compute rank-one-out conformal prediction intervals on the full model
  auto roo = roo_split_cp(X, y, train_fun, predict_fun, alpha, I);
  arma::vec y_pred_f = roo["y_pred"];
  arma::vec lb_f = roo["lb"];
  arma::vec ub_f = roo["ub"];

  for (int k = 0; k < 2; k++) {
    arma::mat X_train = X.rows(I[k]);
    arma::vec y_train = y(I[k]);
    arma::mat X_cal = X.rows(I[1 - k]);
    arma::vec y_cal = y(I[1 - k]);

    for (int j = 0; j < p; j++) {
      // Drop j-th covariate
      arma::mat X_train_j = X_train;
      X_train_j.shed_col(j);
      arma::mat X_cal_j = X_cal;
      X_cal_j.shed_col(j);

      // Train model with I[k] and compute predictions on I[1 - k]
      auto model_j = train_fun(X_train_j, y_train);
      arma::vec y_pred_j = as<arma::vec>(predict_fun(model_j, X_cal_j));

      // Compute the prediction intervals
      for (int i = 0; i < I[1 - k].n_elem; i++) {
        int ii = I[1 - k](i);
        if (y_pred_f(ii) >= y_pred_j(i)) {
          lb(ii, j) = lb_f(ii) + (y_pred_f(ii) - y_pred_j(i));
          ub(ii, j) = ub_f(ii) + (y_pred_f(ii) - y_pred_j(i));
        } else {
          lb(ii, j) = lb_f(ii) - (y_pred_j(i) - y_pred_f(ii));
          ub(ii, j) = ub_f(ii) - (y_pred_j(i) - y_pred_f(ii));
        }
      }
    }
  }

  return List::create(Named("lb") = lb, Named("ub") = ub);
}
