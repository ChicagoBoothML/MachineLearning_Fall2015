from numpy import sqrt


def mse(y_hat, y):
    return ((y_hat - y) ** 2).mean()


def rmse(y_hat, y):
    return sqrt(mse(y_hat, y))
