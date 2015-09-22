# **Computing Resources**

This page contains links to software installation guides and some resources for R (our main computing platform)
and Python (the best alternative).

There is a great deal of parallelism between the R and Python ecosystems
of Machine Learning / Data Science and related software.
Here is a brief table of comparison between the two ecosystems,
including the leading who's-whos and what's-whats in various aspects:

|                                             | R                                                      | PYTHON                                    |
|:--------------------------------------------|:-------------------------------------------------------|:------------------------------------------|
| **Linear Algebra**                          | *(built-in)*                                           | NumPy                                     |
| **Go-To Package for Popular ML Algos**      | caret                                                  | SciKit-Learn                              |
| **Data Frame for Data Processing**          | data.frame, data.table                                 | Pandas                                    |
| **Visualization**                           | ggplot2, ggvis, dygraphs                               | MatPlotLib, GGPlot, Bokeh, Plotly, Pyxley |
| **Large-Scale Parallel Computation**        | parallel, doMC, doParallel, snow                       | Apache Spark, Theano, Numba               |
| **Symbolic Math**                           | Ryacas, rSymPy                                         | SymPy                                     |
| **Dynamic Document Editors / Generators**   | R Markdown, Slidify                                    | iPython Notebook                          |
| **App Development Frameworks**              | Shiny                                                  | Django                                    |
| **Software Unit-Testing Frameworks**        | testthat                                               | Nose, DocTest, Py.Test, PyUnit, Tox       |
| **Leading Developers**                      | RStudio, Revolution Analytics *(Microsoft subsidiary)* | Continuum Analytics, Enthought            |
| **Popular Integrated Devt. Envirs. (IDEs)** | RStudio                                                | PyCharm, Spyder, Rodeo                    |


## R Resources 

We will be using R as the main platform to perform data analysis in the class, however, you are welcome to use
any other tool/programming language you are familiar with.

We strongly encourage you to get familiar with the basics of R, so that you can focus on Machine Learning.
We will go through examples in R in-class and we will provide some instructions. We do not expect
you to have taken a class that uses R previously. That said, this class is not a class on R.

- [**R, RStudio and CRAN Packages** installation guides](Installation/R, RStudio & CRAN Packages.md)
- [**Rob's notes on R**](http://www.rob-mcculloch.org/2015_exec_data_mining/Simple-R-Introduction.pdf)
- [**R's Introduction to R**](https://cran.r-project.org/doc/manuals/R-intro.pdf):
This is written by stat/computing geeks for stat/computing geeks. It is not always the easiest thing to read.
That being said, if you want to learn R, you should read at least the first bit of the chapter on major topics (e.g. data frames).
- The optional textbook ***An Introduction to Statistical Learning*** has a section 2.3 dedicated to the basics of R
- [**R Reference Card**](http://cran.r-project.org/doc/contrib/Short-refcard.pdf)
- [**Google's R Tutorial**](http://www.youtube.com/playlist?list=PLOU2XLYxmsIK9qQfztXeybpHvru-TrqAP)
- [**Princeton's R Tutorial**](http://data.princeton.edu/R)
- [**R Markdown** tutorial](Tutorials/R Markdown Tutorial.md): a tutorial by Vinh on R Markdown,
an excellent dynamic document generator that **we strongly recommend that you use to do your homework**.
It will save you a ton of time, and its output will be easy on the eye,
adding extra shine to your already brilliant analysis...
    - Please note that R Markdown requires [**TeX**](Installation/TeX) for conversion to PDF
- [**R data.table** tutorial](Tutorials/R data.table Tutorial.md): a tutorial by Vinh on R `data.table`,
an advanced, high-performance alternative to R's default `data.frame`
- [**Introduction to the *caret* Package**](http://cran.r-project.org/web/packages/caret/vignettes/caret.pdf):
***caret*** is a popular R package providing standardized interfaces with about 200 Machine Learning algorithms
and many related data-processing procedures
- Google and question answering web-page [StackOverflow](http://stackoverflow.com)
- There are many books and tutorials on R.
If you find something that you find particularly useful, please share it with us on Piazza.


## Python Resources

- [**Anaconda Python, PyCharm IDE, and Conda & PyPI Packages** installation guides](Installation/Python Anaconda, PyCharm IDE, and Conda & PyPI Packages.md)
- [**Theano package** installation guide](Installation/Python Theano.md)
- [**iPython Notebook** tutorial](Tutorials/Python iPython Notebook tutorial.md): a tutorial by Vinh on
iPython Notebook, an super-excellent dynamic document editor / generator built on Python,
and a perfect answer to the aforementioned excellent R Markdown. If you do your homework or final project in Python,
**we encourage you to use iPython Notebook to generate your analysis reports**
    - Please note that iPython Notebook requires [**TeX**](Installation/TeX) for conversion to PDF
- [**Pandas** tutorials](http://pandas.pydata.org/pandas-docs/stable/tutorials.html):
`pandas` is a data frame solution in Python &ndash; Python's answer to R's `data.frame` and `data.table`
- [**A Basic Tutorial on SciKit-Learn**](http://scikit-learn.org/stable/tutorial/basic/tutorial.html):
***SciKit-Learn*** is the most popular Python package providing
standardized interfaces with over 100 Machine Learning algorithms and many related data-processing procedures


## Other Software Installation

- [**Git**, **GitHub** & **SourceTree** installation guides](Installation/Git, GitHub & SourceTree.md)
- [**TeX**](Installation/TeX): for rendering math equations in various document formats
- [**Cygwin** installation guide (for Windows users only)](Installation/Cygwin.md):
Cygwin is a Unix-style command-line terminal for Windows
