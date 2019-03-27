#' Compute Range of a variable
#'
#' Computes a reasonable range by adding the standard deviation of a variable to the minimum and maximum value of the variable
#'
#' @param x A numeric vector
#'
#' @return A numeric vector of length 2 where the first element is the lower boundry and the second element is the upper boundry
#' @export
#'
#' @examples
#' compute_range(x = rnorm(100, sd = 4))
#' x <- rnorm(100)
#' y <- rnorm(100, sd = 40)
#' plot(x, y, xlim = compute_range(x), ylim = compute_range(y))
compute_range <- function(x) {
  min_max <- purrr::invoke_map_dbl(.f = list(min, max), x = x)
  sdev <- sd(x)
  min_max + c(-1, 1) * sdev
}

