context("Baysian Model")

data("adoption_data")
model <- bayesian_bass_model()
fit <- bayesian_bass(data = adoption_data, var = "adoption", n_iter = 100, n_thin = 3, model = model)

test_that("Baysian Diffusion model has correct class", {
  testthat::expect_s3_class(fit, "bayesian_bass")
})

test_that("coefficents have correct names", {
  testthat::expect_named(coef(fit), c("p", "q"))
})

test_that("values have the correct data type", {
  testthat::expect_identical(names(fit), c("adoption_rates", "coefs", "rjags_chains", "data"))
  testthat::expect_equal(length(names(fit)), 4)
})

