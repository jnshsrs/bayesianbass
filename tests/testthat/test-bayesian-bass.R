context("Baysian Model")

library(bayesianbass)

data("adoption_data")

model <- bayesian_bass_model()

fitted_bayesian_bass <- bayesian_bass(data = adoption_data, var = "adoption", n_iter = 100, n_thin = 3, model = model)

test_that("Baysian Model has correct class", {
  testthat::expect_s3_class(fitted_bayesian_bass, "bayesian_bass")
})


test_that("coefficents have correct names", {
  testthat::expect_named(coef(fitted_bayesian_bass), c("p", "q"))
})



test_that("values have the correct data type", {
  NULL
  # eg. time index is integer
})

test_that("no missing values in input data", {
  NULL
})



