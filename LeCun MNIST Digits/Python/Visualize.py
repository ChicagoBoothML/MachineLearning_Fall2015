from __future__ import division
from itertools import product
from matplotlib.pyplot import cm, show, subplots
from numpy import array, ceil, floor, nan, set_printoptions, sqrt, zeros

from ChicagoBoothML_Helpy.Print import printflush


def plot_mnist_images(mnist_images, title='', fontsize=12):
    nb_digits, nb_rows, nb_cols = mnist_images.shape
    nb_plot_rows = int(floor(sqrt(nb_digits)))
    nb_plot_cols = int(ceil(nb_digits / nb_plot_rows))
    a = zeros((nb_plot_rows * nb_rows, nb_plot_cols * nb_cols))
    k = -1
    for i, j in product(range(nb_plot_rows), range(nb_plot_cols)):
        k += 1
        if k < nb_digits:
            a[(i * nb_rows):((i + 1) * nb_rows), (j * nb_cols):((j + 1) * nb_cols)] = mnist_images[k]
    fig, ax = subplots()
    fig.suptitle(title, fontsize=fontsize)
    ax.matshow(a, cmap=cm.Greys_r, interpolation='nearest')
    ax.get_xaxis().set_visible(False)
    ax.get_yaxis().set_visible(False)
    show()


def print_digit_labels(digit_labels):
    nb_digits = len(digit_labels)
    nb_rows = int(floor(sqrt(nb_digits)))
    nb_cols = int(ceil(nb_digits / nb_rows))
    a = array([nb_cols * [''] for _ in range(nb_rows)], dtype=object)
    k = -1
    for i, j in product(range(nb_rows), range(nb_cols)):
        k += 1
        if k < nb_digits:
            a[i, j] = digit_labels[k]
    set_printoptions(threshold=nan)
    printflush(a)
