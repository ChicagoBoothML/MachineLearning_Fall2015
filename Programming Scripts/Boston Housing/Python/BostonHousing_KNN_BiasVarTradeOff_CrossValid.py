# import:
from __future__ import division, print_function
from matplotlib.pyplot import figure, legend, plot, scatter, show, suptitle, xlabel, ylabel
from numpy import atleast_2d, log, sqrt
from pandas import read_csv
from sklearn import cross_validation
from sklearn.neighbors import KNeighborsRegressor

# CONSTANTS
NB_CROSS_VALIDATION_FOLDS = 5

# read Boston Housing data into data frame
boston_housing_data = read_csv(
    'https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Boston%20Housing/DATA_BostonHousing.csv')
boston_housing_data.sort(columns='lstat', inplace=True)
print("BOSTON HOUSING data frame's top rows:")
print(boston_housing_data[:6])

# extract X as 2D matrix (compatible with SciKit-Learn)
X = atleast_2d(boston_housing_data['lstat']).T
print('X (lstat):')
print(X[:6])

# extract y as 2D matrix (compatible with SciKit-Learn)
y = atleast_2d(boston_housing_data['medv']).T
print('y (medv):')
print(y[:6])


# define Root-Mean-Square-Error scoring/evaluation function
def rmse_score(estimator, X, y):
    y_predicted = estimator.predict(X)
    nb_cases = len(y)
    return sqrt(((y_predicted - y) ** 2).sum() / nb_cases)


k = 10
knn_algo_10neighbors = KNeighborsRegressor(n_neighbors=k)
knn_fitted_model = knn_algo_10neighbors.fit(X, y)
y_predicted = knn_fitted_model.predict(X)

# plot
figure(figsize=(12, 9))
suptitle('KNN regresssion with k = %i' % k, fontsize=20)
xlabel('lstat')
ylabel('medv')
scatter(X, y, color='blue', s=3, label='actual median house value')
plot(X, y_predicted, color='red', label='predicted')
legend()
print('Please CLOSE PLOT after reviewing it, so that the program can continue...')
show()


rmse_scores = cross_validation.cross_val_score(knn_algo_10neighbors, X, y,
                                               cv=NB_CROSS_VALIDATION_FOLDS,
                                               scoring=rmse_score)

print('RMSE scores across %s cross-validation folds for K = %s:' %(NB_CROSS_VALIDATION_FOLDS, k))
print(rmse_scores)

average_cross_validation_rmse = []
k_range = range(2, 201)

for k in k_range:
    knn_algo_10neighbors = KNeighborsRegressor(n_neighbors=k)
    rmse_scores = cross_validation.cross_val_score(knn_algo_10neighbors, X, y,
                                                   cv=NB_CROSS_VALIDATION_FOLDS,
                                                   scoring=rmse_score)
    average_cross_validation_rmse.append(rmse_scores.mean())

# plot
figure(figsize=(12, 9))
xlabel('model complexity (-log K)')
ylabel('cross-validation RMSE')
plot(- log(k_range), average_cross_validation_rmse)
print('Please CLOSE PLOT after reviewing it, so that the program can continue...')
show()

# select best K
best_k_index = average_cross_validation_rmse.index(min(average_cross_validation_rmse))
best_k = k_range[best_k_index]
print('Best K =', best_k)

k = best_k
knn_algo_10neighbors = KNeighborsRegressor(n_neighbors=k)
knn_fitted_model = knn_algo_10neighbors.fit(X, y)
y_predicted = knn_fitted_model.predict(X)

# plot
figure(figsize=(12, 9))
suptitle('KNN regression with k = %i' % k, fontsize=20)
xlabel('lstat')
ylabel('medv')
scatter(X, y, color='blue', s=3, label='actual median house value')
plot(X, y_predicted, color='red', label='predicted')
legend()
print('Please CLOSE PLOT after reviewing it, so that the program can continue...')
show()
