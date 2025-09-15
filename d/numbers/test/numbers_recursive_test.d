import std.stdio;
import numbers_recursive;

unittest {
    assert(fibonacci(5) == 5);
}

unittest {
    assert(factorial(5) == 120);
}

unittest {
    assert(sum_numbers(5) == 15);
}