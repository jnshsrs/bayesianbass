library(testthat)
library(bayesianbass)

testthat::context("test compute_range")

x <- rnorm(100)
range <- compute_range(x)

testthat::test_that("output has correct length", {
  expect_length(range, 2)
})

