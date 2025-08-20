library(testthat)

source("calculator.R")

test_that("addition works correctly", {
  expect_equal(add(2, 3), 5)
})

test_that("subtraction works correctly", {
  expect_equal(subtract(5, 3), 2)
})