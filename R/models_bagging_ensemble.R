#' Fit models using various methods including single, bagging, and ensemble approaches.
#'
#' This function provides a flexible interface for fitting different statistical and machine learning models
#' to a dataset. It supports fitting single models, multiple models with bagging, or a combination of models
#' with an ensemble approach.
#'
#' @param X A matrix of predictor variables where each column is a predictor and each row an observation.
#' @param y A vector of the response variable corresponding to observations in X.
#' @param model_type A character string specifying the type of single model to fit when not using ensemble.
#'                   Valid inputs: 'linear', 'logistic', 'ridge', 'lasso', 'elastic_net', 'randomForest'.
#'                   This parameter is ignored if ensemble is TRUE.
#' @param bagging A logical indicating whether bagging should be applied. If TRUE, the specified model_type is used
#'                to fit multiple models on bootstrap samples. This parameter is ignored if ensemble is TRUE.
#' @param ensemble A logical indicating whether an ensemble of different model types should be used. If TRUE,
#'                 model_types must be provided, and model_type must be NULL.
#' @param R The number of bootstrap replicates for the bagging process. Only relevant if bagging is TRUE.
#' @param model_types An optional vector of model types to use in the ensemble. Required and must not be NULL
#'                    if ensemble is TRUE.
#' @param ntree The number of trees to be used in the Random Forest model, applicable only if 'randomForest'
#'              is specified in model_type or included in model_types.
#'
#' @return Depending on the configuration, the function returns:
#'         - A single model object if neither bagging nor ensemble is used.
#'         - A list of model objects if bagging is used.
#'         - A list of model objects from different types if ensemble is used.
#'
#' @examples
#' X <- matrix(rnorm(100 * 10), ncol = 10)
#' y <- rbinom(100, 1, 0.5)
#' model_lin <- fitModel(X, y, model_type = "linear")
#' model_bag <- fitModel(X, y, model_type = "linear", bagging = TRUE, R = 50)
#' model_ens <- fitModel(X, y, ensemble = TRUE, model_types = c("linear", "ridge"))
#'
#' @note It is essential to ensure that the provided X is a non-empty matrix and y is a non-empty vector.
#'       The function performs a data check and will stop if inputs do not meet the requirements or if
#'       the configuration of parameters is invalid, such as specifying both model_type and ensemble or
#'       attempting to use both bagging and ensemble simultaneously.
#' @export
fitModel <- function(X, y, model_type = NULL, bagging = FALSE, ensemble = FALSE, R = 100, model_types = NULL, ntree = 500) {
  if (!is.matrix(X) || nrow(X) == 0 || ncol(X) == 0) {
    stop("X must be a non-empty matrix.")
  }
  if (length(y) == 0) {
    stop("y must be a non-empty vector.")
  }

  if (is.null(model_type) && !ensemble) {
    stop("Specify a model_type unless using ensemble.")
  } else if (!is.null(model_type) && ensemble) {
    stop("model_type must be NULL when using ensemble.")
  } else if (bagging && ensemble) {
    stop("Bagging and ensemble cannot be performed together.")
  } else if (ensemble && is.null(model_types)) {
    stop("Specify model_types when using ensemble.")
  }

  data_check <- check_data(X, y)
  if (is.null(data_check) || is.null(data_check$X) || is.null(data_check$y)) {
    stop("Data check failed, input may be incorrect or missing.")
  }

  X <- data_check$X
  y <- data_check$y

  if (ensemble) {
    return(use_ensemble_fit(X, y, model_types, ntree))
  } else if (bagging) {
    return(use_bagging_fit(model_type, X, y, R))
  } else {
    switch(model_type,
           "linear" = LinearModel_func(X, y),
           "logistic" = LogisticModel_func(X, y),
           "ridge" = RidgeModel_func(X, y),
           "lasso" = LassoModel_func(X, y),
           "elastic_net" = ElasticNetModel_func(X, y),
           "randomForest" = RandomForestModel_func(X, y, ntree),
           stop("Invalid model type: ", model_type))
  }
}
