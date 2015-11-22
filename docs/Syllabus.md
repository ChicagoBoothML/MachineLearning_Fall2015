# **Lectures**

The schedule below is tentative and subject to change, depending on time and class interests.
We will move at a pace dictated by class discussions. Please check this page often for updates.

| Week                  | Date                | Content                                                                          |
|:----------------------|:--------------------|:---------------------------------------------------------------------------------|
| [**1**](#weeks-1-2)   | 9/24 &ndash; 9/26   | Intro to  Machine Learning; Nearest Neighbours; Bias-Variance Trade-Off          |
| [**2**](#weeks-1-2)   | 10/1 &ndash; 10/3   | Cross Validation                                                                 |
| [**3**](#week-3)      | 10/8 &ndash; 10/10  | Decision Trees; Bagging and Random Forests; Boosting and Boosted Additive Models |
| [**4**](#week-4)      | 10/15 &ndash; 10/17 | Categorical Outcomes and Classification Models                                   |
| [**5**](#week-5)      | 10/22 &ndash; 10/24 | Logistic regression and Intro to Neural networks                                 |
| [**6**](#week-6)      | 10/29 &ndash; 10/31 | Neural Networks                                                                  | 
| [**7**](#week-7)      | 11/5 &ndash; 11/7   | Recommender Systems                                                              |
| [**8**](#week-8)      | 11/12 &ndash; 11/14 | Networks                                                                         |
| [**9**](#weeks-9-10)  | 11/19 &ndash; 11/21 | Naive Bayes; Probabilistic Graphical Models                                      |
| [**10**](#weeks-9-10) | 12/3 &ndash; 12/5   | Hidden Markov Models (If time permits: anomaly detection in time series)         |
| 11                    | 12/11               | Final Project due                                                                |


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
[knn-bagging.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture03/knn-bagging.R) <br>
[boosting_demo_1D.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture03/boosting_demo_1D.R) <br>
[boosting_demo_2D.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture03/boosting_demo_2D.R) <br>
[BostonHousing_Trees_RandomForests_BoostedAdditiveModels.Rmd](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Boston%20Housing/R/BostonHousing_Trees_RandomForests_BoostedAdditiveModels.Rmd)

- you can find an advanced version featuring the popular **caret** package and **parallel computation** here: [BostonHousing_Trees_RandomForests_BoostedAdditiveModels_usingCaretPackage.Rmd](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Boston%20Housing/R/BostonHousing_Trees_RandomForests_BoostedAdditiveModels_usingCaretPackage.Rmd)

_**Python code**:_ <br>
[BostonHousing_Trees_RandomForests_BoostedAdditiveModels.ipynb](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Boston%20Housing/Python/BostonHousing_Trees_RandomForests_BoostedAdditiveModels.ipynb)

_Homework assignment:_ See Problem 9.1 in Lecture notes for this week.

- [model answers in R Markdown](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Used%20Cars/R/UsedCars_HW03ans.Rmd)
- [model answers in iPython Notebook](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Used%20Cars/Python/UsedCars_HW03ans.ipynb)

_Optional textbook reading:_ 
An Introduction to Statistical Learning: Chapter 8


## Week 4

_Lecture Slides:_ <br>
[**Classification**](Syllabus/04_classification.pdf) <br>
[**Perceptron**](Syllabus/04_perceptron.pdf) <br>
[**Perceptron -- R Markdown Script to recreate slides**](Syllabus/Perceptron.Rmd.zip)

_**R code**:_ <br>
[fglass.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture04/fglass.R) <br>
[04_kaggle_logit_rf_boost.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture04/04_kaggle_logit_rf_boost.R) <br>
[04_simulation_logit_rf_boost.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture04/04_simulation_logit_rf_boost.R) <br>
[04_tabloid_logit_rf_boost.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture04/04_tabloid_logit_rf_boost.R) <br>
[KaggleCreditScoring_usingCaretPackage.Rmd](http://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Kaggle%20Credit%20Scoring/R/KaggleCreditScoring_usingCaretPackage.Rmd) <br>
[TabloidMarketing_usingCaretPackage.Rmd](http://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Tabloid%20Marketing/R/TabloidMarketing_usingCaretPackage.Rmd)

- The use of **`caret`** package and **parallel computing** is highly encouraged from this point on, especially if you decide to train models on a sizeable Training data set


_**Python code**:_ <br>
[KaggleCreditScoring.ipynb](http://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Kaggle%20Credit%20Scoring/Python/KaggleCreditScoring.ipynb) <br>
[TabloidMarketing.ipynb](http://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Tabloid%20Marketing/Python/TabloidMarketing.ipynb)


_Homework assignment:_  <br>
[04_hw.pdf](Syllabus/04_hw.pdf) <br>
Start early.

- [model answers in R Markdown](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/KDD%20Cup%202009%20Orange%20Customer%20Relationships/R/KDDCup2009_OrangeCustRel_Churn.Rmd); **note**: the whole thing takes a **long time** to run completely
- [model answers in iPython Notebook](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/KDD%20Cup%202009%20Orange%20Customer%20Relationships/Python/KDDCup2009_OrangeCustRel_Churn.ipynb); **note**: the whole thing takes a **long time** to run completely

_Optional textbook reading:_ 
An Introduction to Statistical Learning: Chapter 4 (we will not talk about linear discriminant analysis)

Pedro Domingos: A Few Useful Things to Know about Machine Learning [PDF](http://homes.cs.washington.edu/~pedrod/papers/cacm12.pdf)

D. Sculley et al.: Machine Learning: The High Interest Credit Card of Technical Debt [PDF](http://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43146.pdf)


## Week 5

_Lecture Slides:_ <br>
[**Logistic regression**](Syllabus/05_logistic_regression.pdf) <br>
[**RMarkdown -- Logistic regression**](Syllabus/05_logistic_regression.zip) <br>

_**R code**:_ <br>
[lr_decision_surface.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture05/lr_decision_surface.R) <br>
[we8there.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture05/we8there.R) <br>

Optional textbook reading:_ 
An Introduction to Statistical Learning: Chapter 4, Section 6.2


## Midterm Exam

[**Midterm Exam Questions**](Syllabus/Midterm.pdf)

- model answers in R Markdown:
    - [Question 1]
    - [Question 2]


## Week 6

_Lecture Slides:_ <br>
[**Neural networks**](Syllabus/06_nn.pdf) <br>
[**MNIST example**](Syllabus/06_mnist_example.pdf) <br>

[**ALVINN video**](http://watson.latech.edu/book/intelligence/intelligenceOverview5b4.html)


_**R code**:_ <br>

See our [GitHub](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/tree/master/Programming%20Scripts/Lecture06). <br>
We suggest you to clone the folder "Lecture06" or download all of its content, as the folder contains some pretrained models, which may take a long time to train again.

In order to install h2o package, go to [http://h2o-release.s3.amazonaws.com/h2o/master/3232/index.html](http://h2o-release.s3.amazonaws.com/h2o/master/3232/index.html), click on "INSTALL IN R", and follow instructions.

Alternatively, you can type the following in R:

> source("https://raw.githubusercontent.com/ChicagoBoothML/HelpR/master/booth.ml.packages.R")

[MNISTDigits_NeuralNet.Rmd](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/LeCun%20MNIST%20Digits/R/MNISTDigits_NeuralNet.Rmd)

_**Python code**_ <br>
[MNISTDigits_NeuralNet_KerasPackage.ipynb](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/LeCun%20MNIST%20Digits/Python/MNISTDigits_NeuralNet_KerasPackage.ipynb)


_Homework assignment:_  <br>

[06_hw.pdf](Syllabus/06_hw.pdf) <br>
[ParseData.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/UCI%20Human%20Activity%20Recognition%20Using%20Smartphones/R/ParseData.R)

- [model answers in R Markdown](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/UCI%20Human%20Activity%20Recognition%20Using%20Smartphones/R/HumanActivityRecog_NeuralNet_vs_TreeMethods.Rmd); **note**: the whole thing takes a **long time** to run completely
- [model answers in iPython Notebook](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/UCI%20Human%20Activity%20Recognition%20Using%20Smartphones/Python/HumanActivityRecog_NeuralNet_vs_TreeMethods.ipynb); **note**: the whole thing takes a **long time** to run completely

To load data use:

> source("ParseData.R")
>
> data <- parse_human_activity_recog_data()

Due Sunday, November 8.

_Optional textbook reading:_ 
The Elements of Statistical Learning: Sections 11.3 - 11.5

_Some h2o resources:_

[h2o package](http://h2o-release.s3.amazonaws.com/h2o/master/3232/docs-website/h2o-r/h2o_package.pdf) <br>
[Deep Learning](http://h2o-release.s3.amazonaws.com/h2o/master/3232/docs-website/h2o-docs/booklets/DeepLearning_Vignette.pdf) <br>
[GLM](http://h2o-release.s3.amazonaws.com/h2o/master/3232/docs-website/h2o-docs/booklets/GLM_Vignette.pdf) <br>


## Week 7

_Lecture Slides:_ <br>
[**Recommender Systems**](Syllabus/07_recSystems.pdf) <br>

_**R code**:_ <br>

[simpleScript.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture07/simpleScript.R) This is a toy example illustrating how to compute similarities between users, recommend items and predict ratings. 

[MovieLens_MovieRecommendation.Rmd](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/MovieLens%20Movie%20Recommendation/R/MovieLens_MovieRecommendation.Rmd)

In this lecture, we will be using *recommenderlab* package.

[recommenderlab: Reference manual](https://cran.r-project.org/web/packages/recommenderlab/recommenderlab.pdf) <br>
[recommenderlab: Vignette](https://cran.r-project.org/web/packages/recommenderlab/vignettes/recommenderlab.pdf) <br>


_**Python code**_ <br>
[MovieLens_MovieRecommendation.ipynb]

- _**note**: this script requires **Apache Spark** to be install; also, the Recommender functionalities of Spark MLlib are not as extensive as `recommenderlab` in R_


_Homework assignment:_  <br>

[Assignment](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Lecture07/hw/hw.pdf) <br>
Data: [videoGames.json.gz](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Lecture07/hw/videoGames.json.gz?raw=true) <br>
Starter script: [starterScript.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture07/hw/starterScript.R) 


_Optional reading:_ 

[Amazon.com Recommendations](http://www.cs.umd.edu/~samir/498/Amazon-Recommendations.pdf) <br>
[Cold Start Problem](http://wanlab.poly.edu/recsys12/recsys/p115.pdf) <br>
[Matrix Factorization Techniques For Recommender Systems](http://www2.research.att.com/~volinsky/papers/ieeecomputer.pdf) <br>
[All Together Now: A Perspective on the Netflix Prize](http://www2.research.att.com/~volinsky/papers/chance.pdf)


## Week 8

_Lecture Slides:_ <br>
[**Networks**](Syllabus/08_networks.pdf) <br>
[**Ego nets**](Syllabus/08_Akoglu.pdf)   Slides from [KDD tutorial]([http://www.cs.cmu.edu/~abeutel/kdd2015_tutorial/]) on Graph-Based User Behaviour Modeling 

_**R code**:_ <br>

See our [GitHub](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/tree/master/Programming%20Scripts/Lecture08). <br>

_Homework assignment:_  <br>
[Assignment](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Lecture08/hw/hw.pdf) <br>
Data: [wikipedia.gml](https://github.com/ChicagoBoothML/MachineLearning_Fall2015/blob/master/Programming%20Scripts/Lecture08/hw/wikipedia.gml?raw=true) <br>
Starter script: [starterScript.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture08/hw/starterScript.R) 


_Optional reading:_ 

See Chapters 3 and 4 of "Statistical Analysis of Network Data with R" (PDF available through UChicago library)


## Weeks 9-10

_Lecture Slides:_ <br>
[**Probabilistic Graphical Models**](Syllabus/09_pgm.pdf) <br>

_**R code**:_ <br>

[NB_reviews.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture09/NB_reviews.R). <br>
Large Movie Review Dataset can be downloaded from [here](http://ai.stanford.edu/~amaas/data/sentiment/index.html).  <br>
Direct link to data: [aclImdb_v1.tar.gz](http://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz)


_Homework assignment:_  <br>
[Assignment](Syllabus/09_hw.pdf) <br>
Data: [emails.cvs](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture09/hw/emails.csv)<br>
Starter script: [starterScript.R](https://raw.githubusercontent.com/ChicagoBoothML/MachineLearning_Fall2015/master/Programming%20Scripts/Lecture09/hw/starterScript.R) 

_Optional reading:_

[Andrew Moore's basic probability tutorial](http://www.autonlab.org/tutorials/prob18.pdf) <br>
[Rabiner's Detailed HMMs Tutorial](References/hmms-rabiner.pdf)  <br>
[Text mining package](https://cran.r-project.org/web/packages/tm/vignettes/tm.pdf)  <br>
[Graphical Models with R](http://pi.lib.uchicago.edu/1001/cat/bib/8873052)   