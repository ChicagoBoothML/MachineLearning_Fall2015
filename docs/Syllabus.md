# **Lectures**

The schedule below is tentative and subject to change, depending on time and class interests.
We will move at a pace dictated by class discussions. Please check this page often for updates.

| Week                | Date                | Content                                                                          |
|:--------------------|:--------------------|:---------------------------------------------------------------------------------|
| [**1**](#weeks-1-2) | 9/24 &ndash; 9/26   | Intro to  Machine Learning; Nearest Neighbours; Bias-Variance Trade-Off          |
| [**2**](#weeks-1-2) | 10/1 &ndash; 10/3   | Cross Validation                                                                 |
| [**3**](#week-3)    | 10/8 &ndash; 10/10  | Decision Trees; Bagging and Random Forests; Boosting and Boosted Additive Models |
| [**4**](#week-4)    | 10/15 &ndash; 10/17 | Categorical Outcomes and Classification Models                                   |
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
[BostonHousing_KNN_BiasVarTradeOff_CrossValid.ipynb](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Boston%20Housing/Python/BostonHousing_KNN_BiasVarTradeOff_CrossValid.ipynb)
 
- please save as an iPython Notebook (_.ipynb_) file on your computer and open in an iPython Notebook server session; OR:
- you may also find it in the **Programming Scripts** > **Boston Housing** > **Python** folder
if you have cloned and synced the course GitHub repo down to your computer
- The iPython NBviewer website allows you to view the notebook in a read-only mode

_Homework assignments:_ <br>

[**Homework 01**](Syllabus/01_hw.pdf)

- [model answers in R Markdown](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Used%20Cars/R/UsedCars_HW01ans.Rmd)
- [model answers in iPython Notebook](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Used%20Cars/Python/UsedCars_HW01ans.ipynb)

[**Homework 02**](Syllabus/02_hw.pdf)

- [model answers in R Markdown](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Used%20Cars/R/UsedCars_HW02ans.Rmd)
- [model answers in iPython Notebook](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Used%20Cars/Python/UsedCars_HW02ans.ipynb)

_Optional textbook reading:_ <br>
An Introduction to Statistical Learning: Section 2, Section 5.1, Section 8.1

_Additional reading:_

[**Machine Learning: Trends, Perspectives, and Prospects**](http://www.sciencemag.org/content/349/6245/255.full.pdf) <br>
*M. I. Jordan and T. M. Mitchel* <br>
A *Science* review article from two leading experts in Machine Learning


## Week 3

_Lecture Slides:_ <br>
[**Trees, Bagging, Random Forests and Boosting**](Syllabus/03_trees_bag_boost.pdf)

_**R code**:_ <br>
[knn-bagging.R](Syllabus/knn-bagging.R) <br>
[BostonHousing_Trees_RandomForests_BoostedAdditiveModels.Rmd](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Boston%20Housing/R/BostonHousing_Trees_RandomForests_BoostedAdditiveModels.Rmd)

- you can find an advanced version featuring the popular **caret** package and **parallel computation** here: [BostonHousing_Trees_RandomForests_BoostedAdditiveModels_usingCaretPackage.Rmd](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Boston%20Housing/R/BostonHousing_Trees_RandomForests_BoostedAdditiveModels_usingCaretPackage.Rmd)

_**Python code**:_ <br>
[BostonHousing_Trees_RandomForests_BoostedAdditiveModels.ipynb](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Boston%20Housing/Python/BostonHousing_Trees_RandomForests_BoostedAdditiveModels.ipynb)



_Homework assignment:_ See Problem 9.1 in Lecture notes for this week.

_Optional textbook reading:_ 
An Introduction to Statistical Learning: Chapter 8


## Week 4

_Lecture Slides:_ <br>
[**Classification**](Syllabus/04_classification.pdf) <br>
[**Perceptron**](Syllabus/04_perceptron.pdf)  
[**Perceptron -- R Markdown Script to recreate slides**](Syllabus/Perceptron.Rmd.zip)

_**R code**:_ <br>
[boosting_demo_1D.R](Syllabus/boosting_demo_1D.R) <br>
[boosting_demo_2D.R](Syllabus/boosting_demo_2D.R) <br>
[fglass.R](Syllabus/fglass.R) <br>
[04_kaggle_logit_rf_boost.R](Syllabus/04_kaggle_logit_rf_boost.R) <br>
[04_simulation_logit_rf_boost.R](Syllabus/04_simulation_logit_rf_boost.R) <br>
[04_tabloid_logit_rf_boost.R](Syllabus/04_tabloid_logit_rf_boost.R) <br>


_**Python code**:_ <br>

_Homework assignment:_  <br>
[04_hw.pdf](Syllabus/04_hw.pdf) <br>
Start early.

_Optional textbook reading:_ 
An Introduction to Statistical Learning: Chapter 4 (we will not talk about linear discriminant analysis)

Pedro Domingos: A Few Useful Things to Know about Machine Learning [PDF](http://homes.cs.washington.edu/~pedrod/papers/cacm12.pdf)

D. Sculley et al.: Machine Learning: The High Interest Credit Card of Technical Debt [PDF](http://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43146.pdf)
