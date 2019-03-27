context("Baysian Model")

library(magrittr)
library(bayesianbass)

adoption_rates <- list("1" = .1, "2" = .3, "3" = .5, "4" = .7, "5" = .75)
df <- purrr::map_df(.x = adoption_rates, rbinom, size = 1, n = 10) %>%
  tidyr::gather(key = "time_index", value = "adoption") %>%
  dplyr::mutate_at("time_index", as.integer)

model <- bayesian_bass_model()

fitted_bayesian_bass <- bayesian_bass(data = df, var = "adoption", n_iter = 100, n_thin = 3, model = model)

test_that("Baysian Model has correct class", {
  testthat::expect_s3_class(fitted_bayesian_bass, "bayesian_bass")
})


test_that("coefficents have correct names", {
  testthat::expect_named(coef(fitted_bayesian_bass), c("p", "q"))
})
