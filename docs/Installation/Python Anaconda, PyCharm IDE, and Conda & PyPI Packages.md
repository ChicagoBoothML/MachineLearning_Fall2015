# Python Installation

We recommend Continuum Analytics’ Anaconda distribution of Python v**2.7** and compatible popular scientific computation packages.

Go [**here**](http://www.continuum.io/downloads) to download a graphical installer appropriate for your machine’s

* processor (32-bit / 64-bit), and
* operating system (Mac / Windows).

Run the installer and follow its instructions to install the software into a folder you prefer.

Note that the Anaconda installation folder path **MUST NOT CONTAIN BLANK SPACES**, because spaces occasionally cause bugs in dependent open-source software packages.
￼￼￼
￼￼￼￼
##￼*Anaconda Academic License*

Continuum offers free Anaconda advanced computation optimization add-ons for academic use.

You may obtain an Academic License [**here**](http://store.continuum.io/cshop/academicanaconda) and follow the instructions in the company’s email after you submit your request.

* Among all things, this Academic License gives you a free upgrade of the default BLAS (Basic Linear Algebra Subprograms) libraries of Anaconda Python to Intel’s Math Kernel Library (MKL), which is among the fastest BLAS’es around. This enables faster math, saving time for you and your machine – *and, hell yeah, salvaging a precious little bit more of your machine’s **resale value***! <i class="fa fa-smile-o"></i>

(The commands to install MKL are already included in the pre-included installation script file discussed in section ***Additional Conda & PyPI Packages Installation*** below)
￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼

## JetBrains PyCharm IDE Installation *[Recommended but Optional]*

JetBrains, a vendor of popular integrated development environments (IDEs) for professional software developers, has an excellent IDE named PyCharm for Python.

We recommend PyCharm, but you may feel free to go with any ther Python IDE(s) of your own choice.

If you do opt for PyCharm, go [**here**](http://www.jetbrains.com/pycharm/download) to download its free Community Edition and install it onto your machine.

***Note:** you typically need to manually configure your installed IDE (PyCharm or other) to link it to the a Python backend (“Python interpreter”). There should be easy-to-follow online guides on how to do this for each IDE.*
￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼

# Additional Conda & PyPI Packages Installation

We need to install a number of packages from both Continuum Analytics’ Anaconda and the Python Package Index (PyPI).

* First, make sure you have cloned and synchronized the [**course GitHub repository**](https://github.com/ChicagoBoothML/MachineLearning_Fall2015) onto your machine;

* Open the command-line terminal:
    - **Mac**: via the ***iTerm*** app
    - **Windows**: via the ***Cygwin*** terminal;

* Navigate to the ***[Your Course Repository Folder]*/Software/Python/** folder; and

* Run the folllowing command: **`sh PythonInstallPackages.sh`**
