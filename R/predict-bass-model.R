#' Bass Model Predictions
#'
#' @param object An \code{bayesian_bass} object
#' @params interval An integer vector containing the time points of data collection
#'
#' @return A tibble with two columns, time and prediction
#'
#'
#' @export
#'
#' @examples \dontrun{predict(bass_model)}
predict.bayesian_bass <- function(object, intervals = NULL) {

  if (is.null(intervals)) {
    t <- 0:40
  } else {
    t <- intervals
  }

  p <- coef(object) %>% pluck("p")
  q <- coef(object) %>% pluck("q")

  predicted <- (1 - exp(-(p + q) * t))/(1 + (q/p) * exp(-(p + q) * t))

  tibble::tibble(t = t, predicted = predicted)

}
