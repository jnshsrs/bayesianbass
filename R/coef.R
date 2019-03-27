#' Extract Model Coefficients
#'
#' A function to extract the Bass model coefficients
#'
#' @param x An bayesian_bass object
#'
#' @return A numeric vector containing the coeficients where the first element is p and the second is q
#'
#' @examples
coef.bayesian_bass <- function(x) {
  pluck(x, "coefs")
}
