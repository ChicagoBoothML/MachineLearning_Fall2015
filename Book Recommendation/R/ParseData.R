parse_book_crossing_data <- function(
  data_path='https://raw.githubusercontent.com/ChicagoBoothML/DATA___BookCrossing/master') {

  library(data.table)
  
  # Common NAs:
  na_strings <- c(
    '',
    'na', 'n.a', 'n.a.',
    'nan', 'n.a.n', 'n.a.n.',
    'NA', 'N.A', 'N.A.',
    'NaN', 'N.a.N', 'N.a.N.',
    'NAN', 'N.A.N', 'N.A.N.',
    'nil', 'Nil', 'NIL',
    'null', 'Null', 'NULL')
  
  cat('Parsing Books... ')
  books <- read.csv(
    file.path(data_path, 'BX-Books.csv'),
    sep=';',
    check.names=FALSE,
    colClasses='character',
    stringsAsFactors=FALSE,
    na.strings=na_strings)
  books <- as.data.table(
    books[ , c('ISBN', 'Book-Title', 'Book-Author')])
  names(books) <- c('isbn', 'book_title', 'book_author')
  cat('done!\n')
  
  cat('Parsing Users... ')
  users <- fread(
    file.path(data_path, 'BX-Users.csv'),
    sep=';',
    col.names=c('user_id', 'location', 'age'),
    colClasses='character',
    stringsAsFactors=FALSE,
    na.strings=na_strings,
    showProgress=FALSE)
  users$user_id <- as.integer(users$user_id)
  users$age <- as.numeric(users$age)
  cat('done!\n')
  
  cat('Parsing Ratings... ')
  ratings <- fread(
    file.path(data_path, 'BX-Book-Ratings.csv'),
    sep=';',
    col.names=c('user_id', 'isbn', 'book_rating'), 
    colClasses='character',
    stringsAsFactors=FALSE,
    na.strings=na_strings,
    showProgress=FALSE)
  ratings$user_id <- as.integer(ratings$user_id)
  ratings$book_rating <- as.numeric(ratings$book_rating)
  cat('done!\n')
  
  list(books=books, users=users, ratings=ratings)
}







