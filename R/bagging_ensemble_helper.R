#' Fit models using bagging method
#'
#' This function applies the bagging technique to fit multiple models based on bootstrap samples of the data.
#' It supports various model types and each model is fit on a different sample of the data.
#'
#' @param model_type A character string specifying the type of model to fit. Supported types include "linear",
#' "logistic", "ridge", "lasso", and "elastic_net".
#' @param X A matrix of predictor variables.
#' @param y A vector of response variables.
#' @param R The number of bootstrap replicates to perform.
#'
#' @return A list of model objects, each fitted to a bootstrap sample.
#' @export
use_bagging_fit <- function(model_type, X, y, R) {
  models_list <- list()
  for (i in 1:R) {
    # Sample indices with replacement
    sample_indices <- sample(nrow(X), replace = TRUE)
    X_sample <- X[sample_indices, , drop = FALSE]
    y_sample <- y[sample_indices]

    if(model_type == "linear") {
      model <- LinearModel_func(X_sample, y_sample)
    } else if(model_type == "logistic") {
      model <- LogisticModel_func(X_sample, y_sample)
    } else if(model_type == "ridge") {
      model <- RidgeModel_func(X_sample, y_sample)
    } else if(model_type == "lasso") {
      model <- LassoModel_func(X_sample, y_sample)
    } else if(model_type == "elastic_net") {
      model <- ElasticNetModel_func(X_sample, y_sample)
    } else {
      stop("Unsupported model type: ", model_type)
    }
    models_list[[i]] <- model
  }
  return(models_list)
}





#' Predict using bagging method
#'
#' This function aggregates predictions from multiple models fitted using the bagging method. Depending
#' on the response type of the models, it either averages probabilities or computes the mean prediction.
#'
#' @param models_list A list containing models fitted using the bagging method.
#' @param X_test The predictor matrix for which predictions need to be made.
#'
#' @return A vector of predictions aggregated from all models.
#' @export
use_bagging_predict <- function(models_list, X_test) {
  if (length(models_list) == 0) {
    stop("No models found in models_list.")
  }
  if (is.null(X_test) || nrow(X_test) == 0) {
    stop("X_test is empty or not available.")
  }

  num_models <- length(models_list)
  predictions_matrix <- matrix(nrow = nrow(X_test), ncol = num_models)

  for (i in 1:num_models) {
    model <- models_list[[i]]$model
    model_type <- attr(model, "model_type")

    X_input <- if (model_type %in% c("logistic", "randomForest", "linear")) {
      as.data.frame(X_test)
    } else {
      as.matrix(X_test)
    }
    type <- switch(model_type,
                   linear = "response",
                   logistic = "response",
                   ridge = "response",
                   lasso = "response",
                   elastic_net = "response",
                   randomForest = "prob",
                   "response")

    predictions_matrix[, i] <- predict(model, X_input, type = type)
  }

  response_type <- models_list[[1]]$response_type
  if (response_type == "binary") {
    mean_probabilities <- rowMeans(predictions_matrix)
    return(ifelse(mean_probabilities > 0.5, 1, 0))
  } else {
    return(rowMeans(predictions_matrix))
  }
}






#' Fit models using ensemble method
#'
#' This function fits an ensemble of different model types to the data. Each model type can contribute
#' differently to the final prediction, and ensemble methods can improve prediction accuracy and model robustness.
#'
#' @param X A matrix of predictor variables.
#' @param y A vector of the response variable.
#' @param model_types A vector of character strings specifying the types of models to include in the ensemble.
#' @param ntree Optional; specifies the number of trees if a random forest is part of the ensemble.
#'
#' @return A list of models, each corresponding to a type specified in model_types.
#' @export
use_ensemble_fit <- function(X, y, model_types, ntree) {
  models_list <- list()
  for (model_type in model_types) {
    if (model_type == "linear") {
      model <- LinearModel_func(X,y)
    } else if (model_type == "logistic") {
      model <- LogisticModel_func(X, y)
    } else if (model_type == "ridge") {
      model <- RidgeModel_func(X, y)
    } else if (model_type == "lasso") {
      model <- LassoModel_func(X, y)
    } else if (model_type == "elastic_net") {
      model <- ElasticNetModel_func(X, y)
    } else if (model_type == "randomForest") {
      model <- RandomForestModel_func(X, y, ntree)
    } else {
      stop("Invalid Model Type: ", model_type)
    }
    models_list[[model_type]] <- model
  }
  return(models_list)
}




#' Predict using ensemble method
#'
#' This function aggregates predictions from a list of different models fitted using the ensemble method.
#' It handles different model types and input requirements, ensuring predictions are appropriately averaged.
#'
#' @param models_list A list containing models fitted using the ensemble method.
#' @param X_test The predictor matrix for which predictions need to be made.
#'
#' @return A vector of predictions, aggregated from all models in the ensemble.
#' @export
use_ensemble_predict <- function(models_list, X_test) {
  if (length(models_list) == 0) {
    stop("No models found in models_list.")
  }
  if (is.null(X_test) || nrow(X_test) == 0) {
    stop("X_test is empty or not available.")
  }

  num_models <- length(models_list)
  predictions_matrix <- matrix(nrow = nrow(X_test), ncol = num_models)

  for (model_index in 1:num_models) {
    model <- models_list[[model_index]]$model
    model_type <- attr(model, "model_type")

    if (is.null(model_type)) {
      stop("Model type attribute not found.")
    }

    response_type <- models_list[[model_index]]$response_type

    X_input <- if (model_type %in% c("linear","logistic", "randomForest")) {
      as.data.frame(X_test)
    } else {
      as.matrix(X_test)
    }

    type <- if (response_type == "binary") "response" else "response"
    predictions_matrix[, model_index] <- predict(model, X_input, type = type)
  }

  if (response_type == "binary") {
    mean_probabilities <- rowMeans(predictions_matrix)
    return(ifelse(mean_probabilities > 0.5, 1, 0))
  } else {
    return(rowMeans(predictions_matrix))
  }
}
