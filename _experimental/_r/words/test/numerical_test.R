library(testthat)

source("../src/numerical.R")

test_that("fibonacci", {
  expect_equal(fibonacci(-3), -1)
  expect_equal(fibonacci(10), 55)
  expect_equal(fibonacci(15), 610)
})

test_that("factorial", {
  expect_equal(factorial(-3), -1)
  expect_equal(factorial(5), 120)
  expect_equal(factorial(10), 3628800)
})

test_that("greatest common divisor", {
  expect_equal(gcd(48, 18), 6)
  expect_equal(gcd(100, 25), 25)
  expect_equal(gcd(17, 13), 1)
})

test_that("least common multiple", {
  expect_equal(lcm(4, 6), 12)
  expect_equal(lcm(21, 6), 42)
  expect_equal(lcm(7, 3), 21)
})