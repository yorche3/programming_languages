#!/usr/bin/julia

module NumericalSuite

using Test
include("../src/Numerical.jl")
using .Numerical

@testset "Numerical Suite" begin
  @testset "Fibonacci" begin
    @test fibonacci(-3) == -1
    @test fibonacci(10) == 55
    @test fibonacci(15) == 610
  end

  @testset "Factorial" begin
    @test factorialy(-3) == -1
    @test factorialy(5) == 120
    @test factorialy(10) == 3628800
  end

  @testset "Greatest Common Divisor" begin
    @test gcdy(48, 18) == 6
    @test gcdy(100, 25) == 25
    @test gcdy(17, 13) == 1
  end
  
  @testset "Least Common Multiple" begin
    @test lcmy(4, 6) == 12
    @test lcmy(21, 6) == 42
    @test lcmy(7, 3) == 21
  end
end

end