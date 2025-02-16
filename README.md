# R_Package
## 👀Overview
Our package will implement the following models:
- linear or logistic regression
- ridge regression (for binary and continuous y)
- lasso regression (for binary and continuous y)
- elastic net (for binary and continuous y)
- another machine learning model
- Importing R packages glmnet, e1071 (for SVM), randomForest, and xgboost (for boosted trees) and use the functions in these packages.

### 🎯Description
- The r package will take as input a response variable y and a matrix of candidate predictors/independent variables X, where each column is a predictor.
- Package will work for both binary y and continuous y (for continuous case, it can be assumed to be normally distributed).
- The predictors X can be combinations of continuous, discrete, and binary predictors.
- The number of predictors p can be very large (i.e., you should also consider the case where p >> n, n is the sample size).
- Furthermore, to improve the robustness of model fit, the  package will also have the option to perform “bagging” for linear, logistic, ridge, lasso, and elastic net models.
- Package will return the final predicted values as the averages of these bagged models. How  will average the bagged models and describe this in your package tutorial page.
- Writing function implementing the bagging approach. 
- Additionally, the package will also return a “naive” variable importance score which counts the number of times each variable is selected in the bagging process.
- If p >> n, the package will also have the option that allows users to pre-screen for top K most “informative” predictors to be included in the model.

### 📂Datasets 
The data is taken from: 
[DATA](https://github.com/GAYATRI-SIVANI-SUSARLA/R_Package/tree/main/Data)

### 🔎Handling High-Dimensional Data
One of the significant challenges in statistical modeling is dealing with high-dimensional datasets where the number of predictors (p) is much larger than the number of observations (n). To address this, the package  includes a feature that allows users to perform prescreening of predictors to select the top K most informative predictors. This selection is based on the absolute correlation of each predictor with the response variable, y. The steps are as follows:

1. Correlation Calculation: For each predictor, calculate the Pearson correlation coefficient between the predictor and the response variable.
2. Ranking Predictors: Order the predictors based on the absolute value of their correlation coefficients.
3. Selection of Top K: Allow the user to specify K, the number of top predictors to include in subsequent models. The package then retains only these top K predictors for model fitting.
[More details](https://github.com/GAYATRI-SIVANI-SUSARLA/R_Package/blob/main/Introduction/Introduction.Rmd)

### ✈️Conclusion
The R package is designed to facilitate advanced statistical modeling by integrating various regression and machine-learning techniques into a comprehensive framework. This package allows users to apply single, bagging, and ensemble methods to both binary and continuous response variables using a variety of predictor types. Whether you’re dealing with high-dimensional data where the number of predictors significantly exceeds the number of observations, or you require robust prediction through ensemble methods, the package provides the tools necessary for effective model building and evaluation.









