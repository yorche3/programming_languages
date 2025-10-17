module d.words.test.numerical_test;

import std.stdio;

import numerical;

unittest {
    assert(fibonacci(-3) == -1);
    assert(fibonacci(10) == 55);
    assert(fibonacci(15) == 610);
    writeln("[OK] Fibonacci");
}

unittest {
    assert(factorial(-3) == -1);
    assert(factorial(5) == 120);
    assert(factorial(10) == 3_628_800);
    writeln("[OK] Factorial");
}

unittest {
    assert(gcd(48, 18) == 6);
    assert(gcd(100, 25) == 25);
    assert(gcd(17, 13) == 1);
    writeln("[OK] Greatest Common Divisor");
}

unittest {
    assert(lcm(4, 6) == 12);
    assert(lcm(21, 6) == 42);
    assert(lcm(7, 3) == 21);
    writeln("[OK] Lowest Common Multiple");
}