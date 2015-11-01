parse_human_activity_recog_data <- function(
  data_path='https://raw.githubusercontent.com/ChicagoBoothML/DATA___UCI___HumanActivityRecognitionUsingSmartphones/master',
  X_names_file_name='features.txt',
  train_subfolder_name='train', X_train_file_name='X_train.txt', y_train_file_name='y_train.txt',
  test_subfolder_name='test', X_test_file_name='X_test.txt', y_test_file_name='y_test.txt') {
  
  library(data.table)
  
  cat('Parsing Data Set "UCI Human Activity Recognition Using Smartphones"...\n')
  
  cat("  Parsing Unique Input Features' (X's) Names... ")
  X_names_with_duplicates <- fread(
    file.path(data_path, X_names_file_name),
    header=FALSE, drop=c(1))$V2
  X_unique_names <- sort(unique(X_names_with_duplicates))
  cat('done!\n')
  
  cat('   Parsing Train & Test Input Feature Data Sets... ')
  X_train_with_duplicates <- fread(
    file.path(data_path, train_subfolder_name, X_train_file_name),
    header=FALSE,
    col.names=X_names_with_duplicates,
    colClasses='numeric',
    showProgress=FALSE)
  X_train <- X_train_with_duplicates[ , X_unique_names, with=FALSE]
  X_test_with_duplicates <- fread(
    file.path(data_path, test_subfolder_name, X_test_file_name),
    header=FALSE,
    col.names=X_names_with_duplicates,
    colClasses='numeric',
    showProgress=FALSE)
  X_test <- X_test_with_duplicates[ , X_unique_names, with=FALSE]
  cat('done!\n')
  
  cat('   Parsing Train & Test Labels (y)... ')
  y_class_labels <- c(
    'Walking', 'WalkingUpstairs', 'WalkingDownstairs', 'Sitting', 'Standing', 'Laying')
  
  y_train = factor(
    fread(
      file.path(data_path, train_subfolder_name, y_train_file_name),
      header=FALSE,
      showProgress=FALSE)$V1,
    levels=1 : 6,
    labels=y_class_labels)
  
  y_test = factor(
    fread(
      file.path(data_path, test_subfolder_name, y_test_file_name),
      header=FALSE,
      showProgress=FALSE)$V1,
    levels=1 : 6,
    labels=y_class_labels)
  cat('done!\n')
  
  cat('   Removing Data Rows with Missing (NaN) Values... ')
  train_rows_not_na_yesno <- !is.na(rowSums(X_train))
  X_train <- X_train[train_rows_not_na_yesno, ]
  y_train <- y_train[train_rows_not_na_yesno]
  test_rows_not_na_yesno <- !is.na(rowSums(X_test))
  X_test <- X_test[test_rows_not_na_yesno]
  y_test = y_test[test_rows_not_na_yesno]
  cat('done!\n')
  
  list(X_train=X_train, y_train=y_train, X_test=X_test, y_test=y_test)
}
