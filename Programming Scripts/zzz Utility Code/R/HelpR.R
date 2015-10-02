mse <- function(y_hat, y) {
  mean((y_hat - y) ^ 2)
}

rmse <- function(y_hat, y) {
  sqrt(mse(y_hat, y))
}
