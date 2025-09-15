#!/usr/bin/julia

using Test
include("../src/NumbersIterative.jl")
using .NumbersIterative

@testset "Iterative Tests" begin
  @testset "Fibonacci Tests" begin
    @test fibonacci(5) == 5
  end

  @testset "Factorial Tests" begin
    @test factorial(5) == 120
  end

  @testset "Sum Numbers Tests" begin
    @test sum_numbers(5) == 15
  end
end