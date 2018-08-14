library(testthat)

context("pysd2r tests...")

test_that("Vensim mdl file is available ...", {
  target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
  expect_true(grepl("models/vensim/Population.mdl", target))
})

test_that("Xmile mdl file is available ...", {
  target <- system.file("models/xmile", "Population.xmile", package = "pysd2r")
  expect_true(grepl("models/xmile/Population.xmile", target))
})

test_that("Connection to pysd vensim model reads ok...", {
  skip_on_cran() # as pysd may not be installed on CRAN
  target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
  py <- pysd_connect()
  py <- read_vensim(py, target)
  expect_equal(py$model$components$initial_time(), 1960)
})

test_that("Connection to pysd vensim xmile reads ok...", {
  skip_on_cran() # as pysd may not be installed on CRAN
  target <- system.file("models/xmile", "Population.xmile", package = "pysd2r")
  py <- pysd_connect()
  py <- read_xmile(py, target)
  expect_equal(py$model$components$initial_time(), 1)
})

test_that("Test that simulation runs ok...", {
  skip_on_cran() # as pysd may not be installed on CRAN
  target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
  py <- pysd_connect()
  py <- read_vensim(py, target)
  out <- run_model(py)
  expect_equal(round(out$Population[401],3),6346.542)
})



