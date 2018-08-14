library(testthat)
library(pysd2r)

context("pysd2r tests...")

test_that("Connection to pysd vensim model reads ok...", {
  target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
  py <- pysd_connect()
  py <- read_vensim(py, target)
  expect_equal(py$model$components$initial_time(), 1960)
})

test_that("Connection to pysd vensim xmile reads ok...", {
  target <- system.file("models/xmile", "Population.xmile", package = "pysd2r")
  py <- pysd_connect()
  py <- read_xmile(py, target)
  expect_equal(py$model$components$initial_time(), 1)
})

test_that("Test that simulation runs ok...", {
  target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
  py <- pysd_connect()
  py <- read_vensim(py, target)
  out <- run_model(py)
  expect_equal(round(out$Population[401],3),6346.542)
})



