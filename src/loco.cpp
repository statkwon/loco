#include <RcppArmadillo.h>

using namespace Rcpp;

// [[Rcpp::export]]
arma::mat loco_c(const arma::mat& X, const arma::vec& y, Function mean_fun, Function predict_fun, int n_train) {
  int n = X.n_rows;
  int p = X.n_cols;
  arma::mat Delta(n - n_train, p);

  // Randomly choose n_train indices for training set
  arma::uvec indices = arma::randperm(n, n_train);

  // Split data into training and calibration sets
  arma::mat X_train = X.rows(indices);
  arma::vec y_train = y.elem(indices);
  arma::mat X_cal = X;
  X_cal.shed_rows(indices);
  arma::vec y_cal = y;
  y_cal.shed_rows(indices);

  // Fit the full model and compute residuals
  auto model = mean_fun(X_train, y_train);
  arma::vec y_pred = as<arma::vec>(predict_fun(model, X_cal));
  arma::vec residual = abs(y_cal - y_pred);

  // Fit leave-one-out models and compute residuals
  for (int j = 0; j < p; j++) {
    // Remove j-th covariate
    arma::mat X_train_j = X_train;
    X_train_j.shed_col(j);
    arma::mat X_cal_j = X_cal;
    X_cal_j.shed_col(j);

    // Fit model without j-th covariate
    auto model_j = mean_fun(X_train_j, y_train);
    arma::vec y_pred_j = as<arma::vec>(predict_fun(model_j, X_cal_j));
    arma::vec residual_j = abs(y_cal - y_pred_j);

    Delta.col(j) = residual_j - residual;
  }

  return Delta;
}
