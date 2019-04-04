context("Test plot functions")

library(bayesianbass)

data("adoption_data")

model <- bayesian_bass_model()
fit <- bayesian_bass(data = adoption_data, var = "adoption", n_iter = 100, n_thin = 3, model = model)
pred_df <- predict(fit)

ggplot_pred_df <- purrr::pluck(pred_df)

test_that("prediction value types of S3 generic are correct and in the expected range", {
  df_pred_interval <- predict(fit, interval = 0:10)
  testthat::expect_equal(dim(df_pred_interval), c(11, 2))
  testthat::expect_equal(ncol(predict(fit)), 2)
  testthat::expect_true(is.integer(pred_df$t))
  testthat::expect_gte(min(pred_df$predicted), 0)
  testthat::expect_lte(max(pred_df$predicted), 1)
})

test_that("Plot works", {
  testthat::expect_equal(ncol(ggplot_pred_df), 2)
  testthat::expect_true(is.integer(ggplot_pred_df$t))
  testthat::expect_gte(min(ggplot_pred_df$predicted), 0)
  testthat::expect_lte(max(ggplot_pred_df$predicted), 1)
})

test_that("Diffusion plot in coherent with bayesian_bass_diffusion class", {
  model <- bayesian_bass_model()
  fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model, n_iter = 1000)
  adoption <- predict_adoption(fit, time = 10)
  diffusion <- predict_diffusion(fit)

  # diffusion
  testthat::expect_equal(names(diffusion), c("diffusion_predicted", "diffusion_data", "diffusion_actual"))
  testthat::expect_equal(class(plot(diffusion)), c("gg", "ggplot"))
  testthat::expect_s3_class(plot(diffusion), c("ggplot"))

  # adoption
  testthat::expect_equal(names(adoption), c("adoption", "time"))
  testthat::expect_equal(class(plot(adoption)), c("gg", "ggplot"))
  testthat::expect_s3_class(plot(adoption), c("ggplot"))

})
