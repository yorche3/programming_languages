#!/usr/bin/julia

using Test
include("../src/Calculator.jl")
using .Calculator

@testset "Calculator Tests" begin
  @testset "Addition Tests" begin
    @test add(2, 3) == 5
  end
  
  @testset "Subtraction Tests" begin
    @test subtract(5, 2) == 3
  end
end