const std = @import("std");
const numbers_iterative = @import("numbers_iterative");

test "iterative Fibonacci" {
    try std.testing.expect(numbers_iterative.fibonacci(5) == 5);
}

test "iterative Factorial" {
    try std.testing.expect(numbers_iterative.factorial(5) == 120);
}

test "iterative Sum of N" {
    try std.testing.expect(numbers_iterative.sum_numbers(5) == 15);
}
