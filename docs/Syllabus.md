# **Lectures**

The schedule below is tentative and subject to change, depending on time and class interests.
We will move at a pace dictated by class discussions. Please check this page often for updates.

| Week                | Date                | Content                                                                          |
|:--------------------|:--------------------|:---------------------------------------------------------------------------------|
| [**1**](#weeks-1-2) | 9/24 &ndash; 9/26   | Intro to  Machine Learning; Nearest Neighbours; Bias-Variance Trade-Off          |
| [**2**](#weeks-1-2) | 10/1 &ndash; 10/3   | Cross Validation                                                                 |
| [**3**](#week-3)    | 10/8 &ndash; 10/10  | Decision Trees; Bagging and Random Forests; Boosting and Boosted Additive Models |
| 4                   | 10/15 &ndash; 10/17 | Categorical Outcomes and Classification Models                                   |
| 5                   | 10/22 &ndash; 10/24 | Neural Networks                                                                  |
| 6                   | 10/29 &ndash; 10/31 | Recommender Systems                                                              | 
| 7                   | 11/5 &ndash; 11/7   | Anomaly Detection                                                                |
| 8                   | 11/12 &ndash; 11/14 | Mining Network Data                                                              |
| 9                   | 11/19 &ndash; 11/21 | Probabilistic Graphical Models; Hidden Markov Models; Naive Bayes                |
| 10                  | 12/3 &ndash; 12/5   | Mining Time Series                                                               |
| 11                  | 12/11               | Final Project due                                                                |


## Weeks 1-2

_Lecture Slides:_ <br>
[**Overview**](Syllabus/01_overview.pdf) <br>
[**Introduction to Predictive Models and kNN**](Syllabus/01_knn.pdf)

_**R code**:_ <br>
[docv.R](https://github.com/ChicagoBoothML/HelpR/blob/master/docv.R) <br>
[bias-variance-illustration.R](Syllabus/bias-variance-illustration.R) <br>
[BostonHousing_KNN_BiasVarTradeOff_CrossValid.Rmd](http://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Boston%20Housing/R/BostonHousing_KNN_BiasVarTradeOff_CrossValid.Rmd)

- please save as a R Markdown (_.Rmd_) file on your computer, open in RStudio, and run by "Knit PDF"; OR:
- you may also find it in the **Programming Scripts** > **Boston Housing** > **R** folder
if you have cloned and synced the course GitHub repo down to your computer
- _**note**: R Markdown requires [**TeX**](Installation/TeX) for conversion to PDF_

_**Python code**:_ <br>
[BostonHousing_KNN_BiasVarTradeOff_CrossValid.ipynb](http://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Boston%20Housing/Python/BostonHousing_KNN_BiasVarTradeOff_CrossValid.ipynb)<br>
_(you can view a read-only version through [NBviewer](http://nbviewer.ipython.org/github/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Boston%20Housing/Python/BostonHousing_KNN_BiasVarTradeOff_CrossValid.ipynb))_
 
- please save as an iPython Notebook (_.ipynb_) file on your computer and open in an iPython Notebook server session; OR:
- you may also find it in the **Programming Scripts** > **Boston Housing** > **Python** folder
if you have cloned and synced the course GitHub repo down to your computer
- The iPython NBviewer website allows you to view the notebook in a read-only mode

_Homework assignments:_ <br>

[**01_hw.pdf**](Syllabus/01_hw.pdf)

- [model answers in R Markdown](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Used%20Cars/R/UsedCars_HW01ans.Rmd)
- [model answers in iPython Notebook](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Used%20Cars/Python/UsedCars_HW01ans.ipynb)
    - view through [NBViewer](http://nbviewer.ipython.org/github/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Used%20Cars/Python/UsedCars_HW01ans.ipynb)

[**02_hw.pdf**](Syllabus/02_hw.pdf)


_Optional textbook reading:_ <br>
An Introduction to Statistical Learning: Section 2, Section 5.1, Section 8.1

_Additional reading:_

[**Machine Learning: Trends, Perspectives, and Prospects**](http://www.sciencemag.org/content/349/6245/255.full.pdf) <br>
*M. I. Jordan and T. M. Mitchel* <br>
A *Science* review article from two leading experts in Machine Learning


## Week 3

_Lecture Slides:_ <br>
[Trees, Bagging, Random Forests and Boosting](Syllabus/03_trees_bag_boost.pdf)  <br>
Note that the first part of the slides are the same as trees in the week 2.

_**R code**:_ <br>
[knn-bagging.R](Syllabus/knn-bagging.R)
[BostonHousing_DecTrees_RandomForests_BoostedAdditiveModels.Rmd](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Boston%20Housing/R/BostonHousing_DecTrees_RandomForests_BoostedAdditiveModels.Rmd)
    - you can find an advanced version featuring the popular **caret** package and **parallel computation** [**here**](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Boston%20Housing/R/BostonHousing_DecTrees_RandomForests_BoostedAdditiveModels_usingCaretPackage.Rmd)

_**Python code**:_ <br>


_Homework assignment:_ See Problem 9.1 in Lecture notes for this week.

_Optional textbook reading:_ 
An Introduction to Statistical Learning: Chapter 8
