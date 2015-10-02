#!/usr/bin/env bash
# The following will install the necessary additional Python packages for this course

# Install Anaconda's add-on packages
conda update conda
conda install Accelerate
conda install IOPro
conda install MKL
conda install Numba
conda install MinGW LibPython
conda update bokeh
conda update scikit-learn

# Install packages from PyPI (Python Package Index)
pip install --upgrade pip

pip install --upgrade GGPlot   # git+git://github.com/yhat/ggplot.git
pip install --upgrade GitPython
pip install --upgrade GraphViz
pip install --upgrade Jupyter
pip install --upgrade MkDocs
pip install --upgrade NeuroLab
pip install --upgrade PyReadLine
pip install --upgrade Python-Markdown-Math

pip uninstall PyParsing   # to install an older version compatible with PyDot (see Stack Overflow thread:
# http://stackoverflow.com/questions/15951748/pydot-and-graphviz-error-couldnt-import-dot-parser-loading-of-dot-files-will)
pip install -Iv https://pypi.python.org/packages/source/p/pyparsing/pyparsing-1.5.7.tar.gz#md5=9be0fcdcc595199c646ab317c1d9a709
pip install PyDot

pip install --upgrade Theano
pip install --upgrade Keras   # depends on Theano
