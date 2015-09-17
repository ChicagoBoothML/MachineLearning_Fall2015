# Theano: Overview

Theano is a Python library that enables using a compatible GPU (Graphical Processing Unit) of the computer for numerical computation, which is far superior in performance terms to computation by the computer’s CPU (Central Processing Unit).

* **Currently, the most, if not only, effectively Theano-supported GPUs are those by NVIDIA**

* Even if your machine do not have an NVIDIA graphics card, Theano is still useful in compiling complex calculations down to highly efficient C / C++ or machine code that can execute very fast
￼￼￼

Because of its huge performance-boosting benefits, Theano is prominent in extremely data-intensive, large-scale Machine Learning applications such as those in cutting-edge Neural Networks-based Deep Learning.

Having said that, Theano is still very young (*"young"* = nice word for *"buggy"*) and its setup, configuration and usage demand a high degree of risk-taking and perseverance. :( *(It helps if you are good with your friends and hence enjoy good karma)*

We will hence use Theano only on a **limited, experimental basis** for some exercises in Neural Networks, and we will install it in such a way that if your computer does not have an NVIDIA GPU, Theano will fall back to NumPy, which is Python’s default numerical computation library.

In case you are unsuccessful in struggling through the Theano installation, we will use a non-Theano-dependent library for the Neural Networks exercises.

￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼
#￼Theano Installation and Configuration on Mac

You may refer to the Theano installation and configuration guide for Mac [**here**](http://deeplearning.net/software/theano/install.html#mac-os).

Appropriate steps vary from machine to machine. Consult ***Dr. Google*** and ***Prof. Stack Overflow** whenever you get stuck.

In the Teaching Assistants’ own experience, the recommended key steps include:

1. Install the **Anaconda Python v2.7 distribution** *(this should be already done, per instructions in a previous section)
2. Install the **additional Conda & PyPI packages** per instructions in the previous section
3. Install the Clang compiler through installing the **XCode app** from the Apple App Store and running XCode once to install its command-line tools
4. Install the [**CUDA graphics driver and toolkit v7**](http://developer.nvidia.com/cuda-downloads) from NDIVIA in order to use the GPU to perform numerical computation
5. Copy the **`.theanorc`** file in the ***[Your Course Repository Folder]**/Computing/Python/Theano/Mac** folder to the **/*[Your Username]*/** home folder, customize the copied file (NOT the original file) according to the comments, and save it
￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼
One common source of error in setting up Theano on Mac concerns the BLAS (Basic Linear Algebra Subprograms) libraries
* Refer [**here**](http://deeplearning.net/software/theano/install.html#troubleshooting-make-sure-you-have-a-blas-library) for some troubleshooting guidance on this issue Verification steps:

Run the **`TheanoTestScript.py`** file in the ***[Your Course Repository Folder]*/Computing/Python/Theano/** folder, either via your Python IDE or through the terminal, and verify that it completes successfully, giving your a comparison of speeds between NumPy and Theano
￼
￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼
#￼Theano Installation and Configuration on Windows

You may refer to the Theano installation and configuration guide for Windows [**here**](http://deeplearning.net/software/theano/install_windows.html).

Appropriate steps vary from machine to machine. Consult ***Dr. Google*** and ***Prof. Stack Overflow*** whenever you get stuck.

In the Teaching Assistants’ own experience, the recommended key steps include:

1. Install the **Anaconda Python v2.7 distribution** *(this should be already done, per instructions in a previous section)
2. Install the **additional Conda & PyPI packages** per instructions in the previous section
3. Find and install [**Visual Studio Community 2013**](http://www.visualstudio.com/downloads/download-visual-studio-vs)
    * *do **NOT** install the 2015 version, which is not compatible with the CUDA software below*
4. Install the [**CUDA graphics driver and toolkit v7**](http://developer.nvidia.com/cuda-downloads) from NDIVIA in order to use the GPU to perform numerical computation
5. Install the [**Microsoft Visual C++ Compiler for Python v2.7**](http://www.microsoft.com/en-us/download/details.aspx?id=44266)
6. Install a **GNU C Compiler (GCC)** such as [**this**](http://tdm-gcc.tdragon.net)
7. Install [**GraphViz**](http://www.graphviz.org/Download.php) into a folder whose path has ***no blank spaces***
8. Open the **`pydot.py`** file in the ***[Your Anaconda Installation Folder]*/lib/site-packages/** folder. Locate the `_find_graphviz` function, comment its whole content out and replace with the following: **`return _find_executables(‘[YOUR GRAPHVIZ INSTALLATION FOLDER]/bin’)`**
9. Copy the **`.theanorc`** file under ***[Your Course Repository Folder]*/Computing/Python/Theano/Windows/** folder to **C:/Users/*[Your Windows User Name]*/.theano/** folder, customize the copied file (NOT the original file) according to the comments, and save it
￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼
Verification steps: open your ***CygWin terminal**and:

* run **`where gcc`** and verify that the path to your GCC installation’s `gcc.exe` file appears
* run **`where nvcc`** and verify that the path to your CUDA installation’s `nvcc.exe` file appears
* run the **`TheanoTestScript.py`** file under ***[Your Course Repository Folder]*/Computing/Python/Theano/**, either via your Python IDE or through the terminal, and verify that it completes successfully, giving your a comparison of speeds between NumPy and Theano
￼￼
￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼
#￼Theano Configurations *[for info only]*

Theano has a large number of configuration levers, the most common of which are discussed [**here**](http://deeplearning.net/software/theano/library/config.html).

You do not need to pay attention to those for this course.
