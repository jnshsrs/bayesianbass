#' Extract Model Coefficients
#'
#' A function to extract the Bass model coefficients
#'
#' @param x An bayesian_bass object
#'
#' @return A numeric vector containing the coeficients where the first element is p and the second is q
#'
#' @export
#'
#' @examples
#' data(adoption_data)
#' model <- bayesian_bass_model()
#' fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
#' coef(fit)
#'
coef.bayesian_bass <- function(x) {
    coefficients <- purrr::pluck(x, "coefs")
    class(coefficients) <- "bass_coefficients"
    return(coefficients)
}

# Compute HDI
