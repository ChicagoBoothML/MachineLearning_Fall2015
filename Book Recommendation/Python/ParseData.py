from pandas import read_csv
from os.path import join

from ChicagoBoothML_Helpy.Print import printflush


def parse_book_crossing_data(
        data_path='https://raw.githubusercontent.com/ChicagoBoothML/DATA___BookCrossing/master'):

    # Common NAs:
    na_strings = [
        '',
        'na', 'n.a', 'n.a.',
        'nan', 'n.a.n', 'n.a.n.',
        'NA', 'N.A', 'N.A.',
        'NaN', 'N.a.N', 'N.a.N.',
        'NAN', 'N.A.N', 'N.A.N.',
        'nil', 'Nil', 'NIL',
        'null', 'Null', 'NULL']

    printflush('Parsing Books...', end=' ')
    books = read_csv(
        join(data_path, 'BX-Books.csv'),
        sep=';',
        dtype=str,
        na_values=na_strings,
        usecols=['ISBN', 'Book-Title', 'Book-Author'],
        error_bad_lines=False)
    printflush('done!')

    printflush('Parsing Users...', end=' ')
    users = read_csv(
        join(data_path, 'BX-Users.csv'),
        sep=';',
        dtype=str,
        na_values=na_strings,
        error_bad_lines=False)
    users['User-ID'] = users['User-ID'].astype(int)
    users['Age'] = users['Age'].astype(float)
    printflush('done!')

    printflush('Parsing Ratings...', end=' ')
    ratings = read_csv(
        join(data_path, 'BX-Book-Ratings.csv'),
        sep=';',
        dtype=str,
        na_values=na_strings,
        error_bad_lines=False)
    ratings['User-ID'] = ratings['User-ID'].astype(int)
    ratings['Book-Rating'] = ratings['Book-Rating'].astype(float)
    printflush('done!')

    return dict(books=books, users=users, ratings=ratings)
