#' Bass Model Predictions
#'
#' @param object An \code{bayesian_bass} object
#' @param interval An integer vector containing the time points of data collection
#'
#' @return A tibble with two columns, time and prediction
#'
#'
#' @export
#'
#' @examples
#' data(adoption_data)
#' model <- bayesian_bass_model()
#' fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
#' predict(fit)
#'
predict.bayesian_bass <- function(obj, intervals = NULL) {

  if (is.null(intervals)) {
    t <- 0:40
  } else {
    t <- intervals
  }

  p <- coef(obj) %>% pluck("p")
  q <- coef(obj) %>% pluck("q")

  predicted <- predict_bass(p, q, t = t)

  tibble::tibble(t = t, predicted = predicted)

}

#' Calcualte the posterior distribution of a Bass Diffusion model prediction
#'
#' This function returns a prediction based on the MCMC sampled rjags chains.
#' The point in time of prediction corresponds to the given time_index
#'
#' @param x
#' @param time_index
#'
#' @return
#' @export
#'
#' @examples
#' data(adoption_data)
#' model <- bayesian_bass_model()
#' fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
#' posterior(fit, time_index = 1)
posterior <- function(x, time_index = 1) {
  params <- list(p <- x %>% pluck("rjags_chains") %>% pull("p"),
                 q <- x %>% pluck("rjags_chains") %>% pull("q"))
  predictions <- pmap_dbl(params, predict_bass, t = time_index)
  class(predictions) <- "bayesian_bass_posterior"
  return(predictions)
}

#' Internal Function used by different predict functions
#'
#' @return
#'
#' @examples
predict_bass <- function(p, q, t) {
  predicted <- (1 - exp(-(p + q) * t))/(1 + (q/p) * exp(-(p + q) * t))
  return(predicted)
}


