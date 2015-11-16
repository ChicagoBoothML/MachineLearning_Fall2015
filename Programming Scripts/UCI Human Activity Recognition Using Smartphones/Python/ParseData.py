from collections import Counter
from numpy import float, int, isnan
from pandas import DataFrame, read_csv
from os.path import join

from ChicagoBoothML_Helpy.Print import printflush


def parse_human_activity_recog_data(
        data_path='https://raw.githubusercontent.com/ChicagoBoothML/DATA___UCI___HumanActivityRecognitionUsingSmartphones/master',
        X_names_file_name='features.txt',
        train_subfolder_name='train', X_train_file_name='X_train.txt', y_train_file_name='y_train.txt',
        test_subfolder_name='test', X_test_file_name='X_test.txt', y_test_file_name='y_test.txt'):
    """
    :param data_path: path of folder containing "Human Activity Recognition Using Smartphones" data set
    :param X_names_file_name: name of file containing X features' names
    :param train_subfolder_name: name of folder containing Training data
    :param X_train_file_name: train_X matrix file
    :param y_train_file_name: train_y labels in integer
    :param test_subfolder_name: name of folder containing Test data
    :param X_test_file_name: test_X matrix file
    :param y_test_file_name: test_y labels in integer
    :return: dict with the following:
    feature_names: list of names of the X features
    train_X: data frame containing the X features for model training
    train_y: data frame containing class labels for model training
    test_X: data frame containing X features for model testing
    test_y: data frame containing class labels for model testing
    """

    printflush('Parsing Data Set "UCI Human Activity Recognition Using Smartphones"...')

    printflush("   Parsing Unique Input Features' (X's) Names... ", end='')
    X_names_with_duplicates = read_csv(
        join(data_path, X_names_file_name).replace('\\', '/'),
        delim_whitespace=True, header=None, index_col=0).iloc[:, 0]
    X_name_counts = Counter(X_names_with_duplicates)
    X_unique_names = list(X_name_counts)
    X_unique_names.sort()
    printflush('done!')

    printflush('   Parsing Train & Test Input Feature Data Sets... ', end='')
    X_train_with_duplicates = read_csv(
        join(data_path, train_subfolder_name, X_train_file_name).replace('\\', '/'),
        delim_whitespace=True, header=None, index_col=False,
        names=X_names_with_duplicates,
        dtype=float, error_bad_lines=False, warn_bad_lines=True)
    X_test_with_duplicates = read_csv(
        join(data_path, test_subfolder_name, X_test_file_name).replace('\\', '/'),
        delim_whitespace=True, header=None, index_col=False,
        names=X_names_with_duplicates,
        dtype=float, error_bad_lines=False, warn_bad_lines=True)
    X_train = DataFrame(index=X_train_with_duplicates.index)
    X_test = DataFrame(index=X_test_with_duplicates.index)
    for x_name in X_unique_names:
        if X_name_counts[x_name] == 1:
            X_train[x_name] = X_train_with_duplicates[x_name]
            X_test[x_name] = X_test_with_duplicates[x_name]
        else:
            X_train[x_name] = X_train_with_duplicates[x_name].iloc[:, 0]
            X_test[x_name] = X_test_with_duplicates[x_name].iloc[:, 0]
    printflush('done!')

    printflush('   Removing Input Feature Data Rows with Missing (NaN) Values... ', end='')
    
    for i in X_train.index:
        if isnan(X_train.loc[i].sum()):
            X_train.drop(i, inplace=True)
    for i in X_test.index:
        if isnan(X_test.loc[i].sum()):
            X_test.drop(i, inplace=True)
    printflush('done!')

    printflush('   Parsing Train & Test Labels (y)... ', end='')

    y_class_labels = 'Walking', 'WalkingUpstairs', 'WalkingDownstairs', 'Sitting', 'Standing', 'Laying'

    y_train = read_csv(
        join(data_path, train_subfolder_name, y_train_file_name).replace('\\', '/'),
        sep=' ', header=None, dtype=int).iloc[:, 0].astype('category')
    y_train.cat.rename_categories(y_class_labels, inplace=True)
    y_train = y_train.loc[X_train.index]

    y_test = read_csv(
        join(data_path, test_subfolder_name, y_test_file_name).replace('\\', '/'),
        sep=' ', header=None, dtype=int).iloc[:, 0].astype('category')
    y_test.cat.rename_categories(y_class_labels, inplace=True)
    y_test = y_test.loc[X_test.index]
    printflush('done!')

    return dict(X_train=X_train, y_train=y_train, X_test=X_test, y_test=y_test)
