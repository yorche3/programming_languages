library(testthat)

source("../src/numbers_iterative.R")

test_that("recursive fibonacci", {
  expect_equal(fibonacci(5), 5)
})

test_that("recursive factorial", {
  expect_equal(factorial(5), 120)
})

test_that("recursive sum_numbers", {
  expect_equal(sum_numbers(5), 15)
})