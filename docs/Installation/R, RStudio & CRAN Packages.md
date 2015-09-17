# R Installation

Go [**here**](http://cran.r-project.org) to download a graphical installer of the latest R version appropriate for your machine’s

* processor (32-bit / 64-bit), and
* operating system (Mac / Windows).

Run the installer and follow its instructions to install the software into a folder you prefer.

It is preferred that the R installation folder path **DO NOT CONTAIN BLANK SPACES**, because spaces occasionally cause bugs in dependent open-source software packages.


## *Extra Steps for Windows Users Only*

Windows users need one extra step to make sure you can run the command `Rscript.exe` from the command-line terminal.

* Go to ***Control Panel*** > ***System*** > ***Advanced System Settings*** > ***Environment Variables***, look under the ***System Variable*** section for the variable `Path`, and append the following path to the existing text:

    **`;<Your R Installation Folder>/bin`**
    
    (note that there should be a semi-colon (`;`) separating the existing path and the appended path, and that there must be no space between that semi-colon and the appended path)

* Open the command-line terminal via ***Start Menu*** > ***Run*** > `cmd`. Enter the following command and verify that it returns the folder path containing the `Rscript.exe` file:

    **`where Rscript`**


# RStudio Installation

RStudio is the most popular integrated development environment (IDE) for R.

Go [**here**](http://www.rstudio.com/products/rstudio) to download a graphical installer of RStudio appropriate for your machine’s

* processor (32-bit / 64-bit), and
* operating system (Mac / Windows).

Run the installer and follow its instructions to install the software into a folder you prefer.


# CRAN Packages Installation

We need to install a number of packages from the **Comprehensive R Archive Network** (**CRAN**), a repository of open-source packages developed in R.

* First, make sure you have cloned and synchronized the [**course GitHub repository**](https://github.com/ChicagoBoothML/MachineLearning_Fall2015) onto your machine;

* Open the command-line terminal:
    - **Mac**: via the ***iTerm*** app
    - **Windows**: via ***Start Menu*** > ***Run*** > `cmd`;
    
* Navigate to the ***[Your Course Repository Folder]*/Computing/R/** folder; and

* Run the command **`Rscript RInstallPackages.R`** to install the R packages necessary for this course
