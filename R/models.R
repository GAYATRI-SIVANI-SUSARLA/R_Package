#'Linear Regression
#' @export
LinearModel_func <- function(X,y){
  result<-check_data(X,y)
  if(result$response_type =="binary"){
    stop("Linear regression requires a continuous response variable.")
  }else{
    model <- lm(result$y ~ ., data = as.data.frame(X))
    attr(model, "model_type") <- "linear"
  }
  return(list(model = model, response_type=result$response_type))
}

#'Logistic Regression
#' @export
LogisticModel_func <- function(X,y){
  result <- check_data(X,y)
  if(is.matrix(X)){
    X <- as.data.frame(X)
  }
  if(result$response_type =="continuous"){
    stop("Logistic regression requires a binary response variable.")
  }else{
    model <- glm(y ~ ., data = as.data.frame(X), family = "binomial")
    attr(model, "model_type") <- "logistic"
  }
  return(list(model = model, response_type=result$response_type))
}

#'Ridge Regression
#' @importFrom glmnet cv.glmnet glmnet
#' @export
RidgeModel_func <- function(X,y){
  result <- check_data(X,y)
  cv <- glmnet::cv.glmnet(X, result$y , alpha = 0)
  model <- glmnet::glmnet(X, result$y, alpha = 0, lambda = cv$lambda.min)
  attr(model, "model_type") <- "ridge"
  return(list(model = model, response_type=result$response_type))
}

#'Lasso Regression
#' @importFrom glmnet cv.glmnet glmnet
#' @export
LassoModel_func <- function(X,y){
  result <- check_data(X,y)
  cv <- glmnet::cv.glmnet(X, result$y, alpha = 1)
  model <- glmnet::glmnet(X, result$y, alpha = 1, lambda = cv$lambda.min)
  attr(model, "model_type") <- "lasso"
  return(list(model = model, response_type=result$response_type))
}

#'Elastic Net Regression
#' @importFrom glmnet cv.glmnet glmnet
#' @export
ElasticNetModel_func <- function(X,y){
  result <- check_data(X,y)
  cv <- glmnet::cv.glmnet(X, result$y, alpha = 0.5)
  model <- glmnet::glmnet(X, result$y, alpha = 0.5, lambda = cv$lambda.min)
  attr(model, "model_type") <- "elastic_net"
  return(list(model = model, response_type=result$response_type))
}

#'Random Forest
#' @importFrom randomForest randomForest
#' @export
RandomForestModel_func <- function(X, y, ntree = 500) {
  result <- check_data(X,y)
  model <- randomForest(X,y, ntree = ntree)
  attr(model, "model_type") <- "randomForest"
  return(list(model = model, response_type=result$response_type))
}


