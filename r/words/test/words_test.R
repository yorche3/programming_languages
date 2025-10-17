library(testthat)

source("../src/words.R")

test_that("reverse string", {
  expect_equal(reverse_string("hello"), "olleh")
  expect_equal(reverse_string("a"), "a")
  expect_equal(reverse_string(""), "")
})

test_that("is palindrome", {
  expect_true(is_palindrome("race car"))
  expect_true(is_palindrome("level"))
  expect_false(is_palindrome("hello"))
  expect_true(is_palindrome("a"))
  expect_true(is_palindrome(""))
})

test_that("is substring", {
  expect_true(kmp_search("test", "this is a test"))
  expect_false(kmp_search("not", "this is a test"))
	expect_true(kmp_search("", "any string"))
	expect_true(kmp_search("abc", "abc"))
	expect_false(kmp_search("abc", "ab"))
})

test_that("longest common subsequence", {
  expect_equal(lcs("AGGTAB", "GXTXAYB"), 4)
	expect_equal(lcs("ABC", "ABC"), 3)
	expect_equal(lcs("abc", "def"), 0)
	expect_equal(lcs("", "abc"), 0)
	expect_equal(lcs("abc", ""), 0)
})