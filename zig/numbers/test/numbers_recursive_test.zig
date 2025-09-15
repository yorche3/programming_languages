const std = @import("std");
const numbers_recursive = @import("numbers_recursive");

test "recursive Fibonacci" {
    try std.testing.expect(numbers_recursive.fibonacci(5) == 5);
}

test "recursive Factorial" {
    try std.testing.expect(numbers_recursive.factorial(5) == 120);
}

test "recursive Sum of N" {
    try std.testing.expect(numbers_recursive.sum_numbers(5) == 15);
}
