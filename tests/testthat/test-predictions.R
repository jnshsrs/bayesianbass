context("Testing different attributes and features of predictions of posterior distributions")



testthat::test_that("the predictions support all necessary features.", {
  data(adoption_data)
  model <- bayesian_bass_model()
  fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
  posterior_distr <- posterior(fit, time = 1)

  testthat::expect_equal(length(posterior_distr), nrow(fit$rjags_chains))
  testthat::expect_true(is.numeric(posterior_distr))
  testthat::expect_gte(min(posterior_distr), 0)
  testthat::expect_lte(max(posterior_distr), 1)
  testthat::expect_s3_class(posterior_distr, "bayesian_bass_posterior")
})



testthat::test_that("the predict diffusion function is ok", {
  data(adoption_data)
  model <- bayesian_bass_model()
  fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
  predicted_diffusion <- predict_diffusion(fit)

  testthat::expect_equal(length(names(predicted_diffusion)), 2)

})
