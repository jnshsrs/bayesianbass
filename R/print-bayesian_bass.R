#' Print bayesian bass model
#'
#' @param x bayesian model
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
print.bayesian_bass <- function(x, ...) {
  print(x %>% pluck("coefs"))
}
