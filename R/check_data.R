#' Calculate Pearson correlation coefficient between two vectors
#' @export
calculate_correlation <- function(x, y) {
  mean_x <- mean(x)
  mean_y <- mean(y)

  numerator <- sum((x - mean_x) * (y - mean_y))
  denominator_x <- sum((x - mean_x)^2)
  denominator_y <- sum((y - mean_y)^2)

  correlation <- numerator / sqrt(denominator_x * denominator_y)

  return(correlation)
}


#' The `check_data` function validates and preprocesses predictor and response data for statistical modeling.
#' It ensures that the predictor matrix X is indeed a matrix, determines whether the response variable y is binary or continuous,
#' and optionally performs feature selection based on the correlation of predictors with the response variable.
#'
#' @param X A matrix of predictor variables where each column represents a predictor and each row an observation.
#'          The function will halt and raise an error if X is not a matrix.
#' @param y The response variable which can be either numeric, binary, or a factor with two levels. The function checks
#'          if y is binary by assessing if it contains exactly two unique values (either in numeric or factor form) and
#'          converts factors to numeric binary format if true. If y is not binary, it is treated as continuous.
#'
#' @return A list containing:
#'         - `response_type`: A character string indicating if `y` is 'binary' or 'continuous'.
#'         - `y`: The response variable, possibly transformed to numeric format if originally binary.
#'         - `X`: The predictor matrix, potentially reduced to the top K predictors based on their correlation with `y`
#'           if a prescreening condition is met and the user consents to prescreening.
#'
#' @details The function first verifies that X is a matrix. It then checks the type of y and sets the response type accordingly.
#'          If the number of predictors in X exceeds the number of observations (rows), the function offers the user the option to
#'          perform prescreening to select the top K most informative predictors. This prescreening involves calculating the
#'          absolute correlation of each predictor with y, ordering them, and selecting the top K. This feature selection is
#'          intended to mitigate issues like overfitting or model complexity in high-dimensional datasets.
#'
#' @note The function requires user interaction when prescreening is applicable. It will stop execution with an error message if
#'       the input types are incorrect or if invalid responses are provided during the interaction. Proper error handling is
#'       included to guide correct usage.

#' @export
check_data <- function(X, y) {
  if (!is.matrix(X)) {
    stop("X must be a matrix.")
  }

  # Determine the response variable type
  if (is.factor(y) && length(levels(y)) == 2) {
    y <- as.numeric(y) - 1
    response_type <- "binary"
  } else if (is.numeric(y) && all(sort(unique(y)) %in% c(0, 1)) && length(unique(y)) == 2) {
    response_type <- "binary"
  } else if (is.numeric(y)) {
    response_type <- "continuous"
  } else {
    stop("y should be numeric, binary, or a factor with two levels.")
  }

  if (ncol(X) > nrow(X)) {
    k_option <- readline(prompt = "The number of predictors is larger than the sample size. Do you want to proceed with prescreening for the top K most informative predictors? (yes/no): ")
    if (tolower(k_option) == "yes") {
      k <- as.integer(readline(prompt = "Enter the number of top informative predictors to include (K): "))
      if (is.na(k) || k <= 0 || k > ncol(X)) {
        stop("Invalid input for K. It must be a positive integer less than or equal to the number of predictors.")
      }

      correlations <- numeric(ncol(X))
      for (i in 1:ncol(X)) {
        correlations[i] <- calculate_correlation(X[, i], y)
      }
      print(correlations)

      top_k_indices <- order(correlations, decreasing = TRUE)[1:k]
      X <- X[, top_k_indices, drop = FALSE]
    } else if (tolower(k_option) != "no") {
      stop("Invalid input. Please enter 'yes' or 'no'.")
    }
  }

  return(list(response_type = response_type, y = y, X = X))
}
