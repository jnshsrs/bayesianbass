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
#' @examples
#' \dontrun{
#' plot(bayesian_bass_model)
#' }
plot.bayesian_bass <- function(x, se = F, ...) {
  pred <- predict(x)
  adoption_rates <- x %>% pluck("adoption_rates")
  p <- ggplot(pred, aes(x = t, y = predicted)) +
    geom_line() +
    geom_point(data = adoption_rates, aes(x = t, y = avg), inherit.aes = FALSE) +
    scale_y_continuous("Proportional Adoption", labels = scales::percent) +
    scale_x_date("Year", date_breaks = "5 years", date_labels = "%Y") +
    theme_minimal()

  if (se) {
    p <- p +
      geom_errorbar(data = adoption_rates, aes(ymin = Lower, ymax = Upper, x = t), width = 250, inherit.aes = FALSE)
  }

  return(p)

}
