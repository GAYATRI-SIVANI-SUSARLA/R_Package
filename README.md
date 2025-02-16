# R_Package
## 👀Overview
Our package will implement the following models:
- linear or logistic regression
- ridge regression (for binary and continuous y)
- lasso regression (for binary and continuous y)
- elastic net (for binary and continuous y)
- another machine learning model
- Importing R packages glmnet, e1071 (for SVM), randomForest, and xgboost (for boosted trees) and use the functions in these packages.

## 🎯Description
- The r package will take as input a response variable y and a matrix of candidate predictors/independent variables X, where each column is a predictor.
- Package will work for both binary y and continuous y (for continuous case, it can be assumed to be normally distributed).
- The predictors X can be combinations of continuous, discrete, and binary predictors.
- The number of predictors p can be very large (i.e., you should also consider the case where p >> n, n is the sample size).
- Furthermore, to improve the robustness of model fit,the  package will also have the option to perform “bagging” for linear, logistic, ridge, lasso and elastic net models.
- Package will return the final predicted values as the averages of these bagged models. How  will average the bagged models and describe this in your package tutorial page.
- Writing function implementing the bagging approach. 
- Additionally, the package will also return a “naive” variable importance score which counts the number of times each variable is selected in the bagging process.
- If p >> n, the package will also have the option that allows users to pre-screening for top K most “informative” predictors to be included in the model.

### Datasets - The data is taken from: [DATA](https://github.com/GAYATRI-SIVANI-SUSARLA/R_Package/tree/main/Data)
