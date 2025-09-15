module test.numbers_iterative_test;

import std.stdio;

import numbers_iterative;

unittest {
    assert(fibonacci(5) == 5);
}

unittest {
    assert(factorial(5) == 120);
}

unittest {
    assert(sum_numbers(5) == 15);
}