% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bagging_ensemble_helper.R
\name{use_bagging_fit}
\alias{use_bagging_fit}
\title{Fit models using bagging method}
\usage{
use_bagging_fit(model_type, X, y, R)
}
\arguments{
\item{model_type}{A character string specifying the type of model to fit. Supported types include "linear",
"logistic", "ridge", "lasso", and "elastic_net".}

\item{X}{A matrix of predictor variables.}

\item{y}{A vector of response variables.}

\item{R}{The number of bootstrap replicates to perform.}
}
\value{
A list of model objects, each fitted to a bootstrap sample.
}
\description{
This function applies the bagging technique to fit multiple models based on bootstrap samples of the data.
It supports various model types and each model is fit on a different sample of the data.
}
