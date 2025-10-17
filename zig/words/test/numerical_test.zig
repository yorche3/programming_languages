const std = @import("std");
const numerical = @import("numerical");

test "Fibonacci" {
    try std.testing.expect(numerical.fibonacci(-3) == -1);
    try std.testing.expect(numerical.fibonacci(10) == 55);
    try std.testing.expect(numerical.fibonacci(15) == 610);
}

test "Factorial" {
    try std.testing.expect(numerical.factorial(-3) == -1);
    try std.testing.expect(numerical.factorial(5) == 120);
    try std.testing.expect(numerical.factorial(10) == 3628800);
}

test "Greatest Common Divisor" {
    try std.testing.expect(numerical.gcd(48, 18) == 6);
    try std.testing.expect(numerical.gcd(100, 25) == 25);
    try std.testing.expect(numerical.gcd(17, 13) == 1);
}

test "Lowest Common Multiple" {
    try std.testing.expect(numerical.lcm(4, 6) == 12);
    try std.testing.expect(numerical.lcm(21, 6) == 42);
    try std.testing.expect(numerical.lcm(7, 3) == 21);
}
