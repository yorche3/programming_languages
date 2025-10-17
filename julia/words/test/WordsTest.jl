#!/usr/bin/julia

using Test
include("../src/Words.jl")
using .Words

@testset "Words Suite" begin
  @testset "Reverse String" begin
    @test reverse_string("hello") == "olleh"
    @test reverse_string("a") == "a"
    @test reverse_string("") == ""
  end

  @testset "Is Palindrome" begin
    @test is_palindrome("race car") == true
    @test is_palindrome("level") == true
    @test is_palindrome("hello") == false
    @test is_palindrome("a") == true
    @test is_palindrome("") == true
  end

  @testset "Is Substring" begin
    @test kmp_search("test", "this is a test") == true
    @test kmp_search("not", "this is a test") == false
    @test kmp_search("", "any string") == true
    @test kmp_search("abc", "abc") == true
    @test kmp_search("abc", "ab") == false
  end

  @testset "Longest Common Subsequence" begin
    @test lcs("AGGTAB", "GXTXAYB") == 4
    @test lcs("ABC", "ABC") == 3
    @test lcs("ABC", "DEF") == 0
    @test lcs("", "ABC") == 0
    @test lcs("ABC", "") == 0
  end
end