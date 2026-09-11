#!/usr/bin/julia

using Pkg
Pkg.activate("..") # Activate the project environment at ../Project.toml

using Test

@testset "All Tests" begin
    println("Running Numerical Tests...")
    include("NumericalTest.jl")

    println("\nRunning Words Tests...")
    include("WordsTest.jl")
end