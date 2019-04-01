#' Plot Bayesian Bass Model
#'
#' Plots the diffusion curve and the actual observed adoption rates on a timeline plot
#'
#' @param x An object of class bayesian_bass
#' @param se Boolian, default FALSE, if TRUE plots 95\% bernoulli confidence intervals of actual observed adoption rates
#' @param ... Arguments to be passed to methods, such as graphical parameters
#'
#' @return A ggplot object
#' @export
#'
#' @import ggplot2
#'
#' @examples
#' data(adoption_data)
#' model <- bayesian_bass_model()
#' fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
#' plot(fit)
#'
plot.bayesian_bass <- function(x, se = F, ...) {

    pred <- predict(x)

    adoption_rates <- x %>% pluck("diffusion_actual")

    p <- ggplot(pred, aes(x = t, y = predicted)) +
      geom_line() +
      geom_point(data = adoption_rates, aes(x = t, y = avg), inherit.aes = FALSE) +
      scale_y_continuous("Proportional Adoption", labels = scales::percent) +
      theme_minimal()

    if (se) {
        p <- p +
          geom_errorbar(data = adoption_rates, aes(ymin = Lower, ymax = Upper, x = t), inherit.aes = FALSE)
    }

    return(p)

}

#' Plot Diffusion Curve
#'
#' @param obj A Bayesian Bass model
#'
#' @return
#' @export
#'
#' @examples
#' data(adoption_data)
#' model <- bayesian_bass_model()
#' fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
#' fit_diffusion <- predict_diffusion(fit)
#' plot(fit_diffusion)
#'
plot.bayesian_bass_diffusion <- function(obj, hdi = TRUE) {

  x <- purrr::pluck(obj, "diffusion_data")

  x <- x %>% mutate(time = as.integer(seq(nrow(.))))

  adoption_rates <- purrr::pluck(obj, "diffusion_actual")

  p <- x %>%
    ggplot(aes(x = time, y = avg_adoption)) +
    geom_line() +
    geom_point(data = adoption_rates, aes(x = t, y = avg), inherit.aes = FALSE) +
    scale_y_continuous("Adoption Rate", labels = scales::percent)

  if (hdi) {
    p +
      geom_line(aes(x = time, y = hdi_lower), col = "grey") +
      geom_line(aes(x = time, y = hdi_upper), col = "grey")
  } else {
    p
  }

}


#' Plot distribution of adoption rate
#'
#' @param obj An object of class \code{bayesian_bass_adoption}
#'
#' @return
#' @export
#'
#' @examples
#' data(adoption_data)
#' model <- bayesian_bass_model()
#' fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
#' fit_adoption <- predict_adoption(fit, time = 1)
#' plot(fit_adoption)
#'
plot.bayesian_bass_adoption <- function(obj, ...) {
  data <- tibble(adoption = unlist(obj))
  data %>%
    ggplot(aes(x = adoption)) +
    geom_density(...) +
    scale_x_continuous("Adoption Rate", label = scales::percent, ...)
}
