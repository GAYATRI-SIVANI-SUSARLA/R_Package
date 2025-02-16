% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bagging_ensemble_helper.R
\name{use_ensemble_predict}
\alias{use_ensemble_predict}
\title{Predict using ensemble method}
\usage{
use_ensemble_predict(models_list, X_test)
}
\arguments{
\item{models_list}{A list containing models fitted using the ensemble method.}

\item{X_test}{The predictor matrix for which predictions need to be made.}
}
\value{
A vector of predictions, aggregated from all models in the ensemble.
}
\description{
This function aggregates predictions from a list of different models fitted using the ensemble method.
It handles different model types and input requirements, ensuring predictions are appropriately averaged.
}
