#!/usr/bin/julia

using Test
include("../src/NumbersRecursive.jl")
using .NumbersRecursive

@testset "Recursive Tests" begin
  @testset "Fibonacci Tests" begin
    @test fibonacci(5) == 5
  end

  @testset "Factorial Tests" begin
    @test factorial_rec(5) == 120
  end

  @testset "Sum Numbers Tests" begin
    @test sum_numbers(5) == 15
  end
end