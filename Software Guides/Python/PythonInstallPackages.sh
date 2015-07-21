#!/usr/bin/env bash
# The following will install the necessary additional Python packages for this course

# Install Anaconda's add-on packages
conda update conda
conda install Accelerate
conda install IOPro
conda install MKL
conda install Numba
conda install MinGW LibPython
conda update scikit-learn

# Install packages from PyPI (Python Package Index)
pip install --upgrade pip

pip install GGPlot
pip install GraphViz
pip install NeuroLab

pip uninstall PyParsing   # to install an older version compatible with PyDot (see Stack Overflow thread:
# http://stackoverflow.com/questions/15951748/pydot-and-graphviz-error-couldnt-import-dot-parser-loading-of-dot-files-will)
pip install -Iv https://pypi.python.org/packages/source/p/pyparsing/pyparsing-1.5.7.tar.gz#md5=9be0fcdcc595199c646ab317c1d9a709
pip install PyDot

pip install Theano
pip install Keras   # depends on Theano
