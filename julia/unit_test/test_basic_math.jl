#!/usr/bin/julia

include("basic_math.jl")
using Base.Test

@testset "BasicMathTest" begin
  @test addition(1,2)  == 3
  @test multiply(1,3)  == 3
end;