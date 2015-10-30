from array import array as py_array
from git import Repo
from numpy import arange, array, int8, uint8, zeros
from os import chmod, remove, rmdir, walk
from os.path import join
from requests import head
from stat import S_IWUSR
from struct import unpack
from tempfile import mkdtemp

from ChicagoBoothML_Helpy.Print import printflush


def parse_MNIST_digits(data_path='https://github.com/ChicagoBoothML/DATA___LeCun___MNISTDigits', digits=arange(10)):

    try:
        status_code = head(data_path).status_code
        valid_url = status_code < 400
    except:
        valid_url = False

    if valid_url:
        printflush('Cloning Data Repository ', data_path, ' to Temporary Folder... ', sep='', end='')
        temp_dir = mkdtemp()
        Repo.clone_from(data_path, temp_dir)
        data_path = temp_dir
        to_delete = True
        printflush('done!')
    else:
        to_delete = False

    printflush('Parsing Data Set "MNIST Hand-Written Digits"... ', end='')

    f = open(join(data_path, 'train-images.idx3-ubyte'), 'rb')
    magic_number, nb_digits, nb_rows, nb_cols = unpack(">IIII", f.read(16))
    nb_pixels = nb_rows * nb_cols
    images = array(py_array("B", f.read()))
    f.close()

    f = open(join(data_path, 'train-labels.idx1-ubyte'), 'rb')
    magic_number, nb_digits = unpack(">II", f.read(8))
    labels = array(py_array("b", f.read()))
    f.close()

    indices = [i for i in range(nb_digits) if labels[i] in digits]
    nb_digits = len(indices)

    train_images = zeros((nb_digits, nb_rows, nb_cols), dtype=uint8)
    train_labels = zeros((nb_digits,), dtype=int8)
    for i in range(nb_digits):
        index = indices[i]
        train_images[i] = array(images[(index * nb_pixels):((index + 1) * nb_pixels)]).reshape((nb_rows, nb_cols))
        train_labels[i] = labels[index]

    f = open(join(data_path, 't10k-images.idx3-ubyte'), 'rb')
    magic_number, nb_digits, nb_rows, nb_cols = unpack(">IIII", f.read(16))
    nb_pixels = nb_rows * nb_cols
    images = array(py_array("B", f.read()))
    f.close()

    f = open(join(data_path, 't10k-labels.idx1-ubyte'), 'rb')
    magic_number, nb_digits = unpack(">II", f.read(8))
    labels = array(py_array("b", f.read()))
    f.close()

    indices = [i for i in range(nb_digits) if labels[i] in digits]
    nb_digits = len(indices)

    test_images = zeros((nb_digits, nb_rows, nb_cols), dtype=uint8)
    test_labels = zeros((nb_digits,), dtype=int8)
    for i in range(nb_digits):
        index = indices[i]
        test_images[i] = array(images[(index * nb_pixels):((index + 1) * nb_pixels)]).reshape((nb_rows, nb_cols))
        test_labels[i] = labels[index]

    printflush('done!')

    if to_delete:
        printflush('Deleting Temporary Data Folder... ', end='')
        for root, dirs, files in walk(data_path, topdown=False):
            for file in files:
                file_path = join(root, file)
                chmod(file_path, S_IWUSR)
                remove(file_path)
            for dir in dirs:
                rmdir(join(root, dir))
        rmdir(data_path)
        printflush('done!')

    return dict(TrainImages=train_images, TrainLabels=train_labels, TestImages=test_images, TestLabels=test_labels)
