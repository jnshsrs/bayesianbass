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

    adoption_rates <- x %>% pluck("adoption_rates")

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
