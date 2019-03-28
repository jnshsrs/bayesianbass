#' Bass Model Predictions
#'
#' @param object An \code{bayesian_bass} object
#'
#' @return A tibble with two columns, time and prediction
#'
#' @export
#'
#' @examples \dontrun{predict(bass_model)}
predict.bayesian_bass <- function(object) {

    t <- 0:40
    p <- object$coefs$p
    q <- object$coefs$q
    introduction <- object$introduction

    predicted <- (1 - exp(-(p + q) * t))/(1 + (q/p) * exp(-(p + q) * t))

    tibble(t = t + introduction, predicted = predicted) %>% mutate_at("t", function(x) parse_date(as.character(x), format = "%Y"))

}

