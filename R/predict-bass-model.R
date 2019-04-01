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

  predicted <- predict_bass(p, q, time = t)

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
predict_bass <- function(p, q, time) {
  predicted <- (1 - exp(-(p + q) * time))/(1 + (q/p) * exp(-(p + q) * time))
  return(predicted)
}


#' Predicts the adoption rate
#'
#' The adoption rate is defined as the proportion of adopters of a specific point of time
#'
#' @param obj An object of class \code{bayesian_bass}
#' @param time An integer value specifing the point in time
#'
#' @return
#' @export
#'
#' @examples
#' data(adoption_data)
#' model <- bayesian_bass_model()
#' fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
#' predict_adoption(fit, time = 1)
predict_adoption <- function(obj, time) {

  coefs <- purrr::pluck(obj, "rjags_chains") %>% as.list()
  x <- purrr::pmap_dbl(coefs, predict_bass, t = time)
  class(x) <- "bayesian_bass_adoption"
  return(x)
}

#' Predict the diffusion based on a bayesian bass model
#'
#' @param obj An object of class \code{bayesian_bass}
#' @param time_index An integer vector conaining a sequence of time intervals
#'
#' @return
#' @export
#'
#' @examples
#' data(adoption_data)
#' model <- bayesian_bass_model()
#' fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
#' predict_diffusion(fit)
predict_diffusion <- function(obj, time_index = NULL) {


  actual_adoption_rates <- purrr::pluck(obj, "adoption_rates")
  upper_limit <- max(purrr::pluck(obj, "data", "time"))
  time_index <- seq(upper_limit)

  diffusion <- purrr::map(.x = time_index, .f = predict_adoption, obj = obj)

  data_diffusion <- tibble::tibble(avg_adoption = purrr::map_dbl(diffusion, mean),
                                   sdev_adoption = purrr::map_dbl(diffusion, sd),
                                   hdi = purrr::map(diffusion, function(x) (HDInterval::hdi(object = x)))) %>%
    mutate(hdi = hdi %>% map(enframe)) %>%
    unnest(hdi) %>%
    spread(key = name, value = value) %>%
    rename(hdi_lower = lower, hdi_upper = upper)

  data <- list(
    "diffusion_predicted" = diffusion,
    "diffusion_data" = data_diffusion,
    "diffusion_actual" = actual_adoption_rates
  )

  class(data) <- "bayesian_bass_diffusion"

  return(data)

}





