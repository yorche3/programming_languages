:- use_module(library(plunit)).
:- consult('../src/numerical.pl').

:- begin_tests(numerical_suite).
test(fibonacci) :-
    fibonacci(-3, Result1),
    assertion(Result1 == -1),
    fibonacci(5, Result2),
    assertion(Result2 == 5),
    fibonacci(8, Result3),
    assertion(Result3 == 21).

test(factorial) :-
    factorial(-3, Result1),
    assertion(Result1 == -1),
    factorial(5, Result2),
    assertion(Result2 == 120),
    factorial(10, Result3),
    assertion(Result3 == 3628800).

test(greatest_common_divisor) :-
    gcd(48, 18, Result1),
    assertion(Result1 == 6),
    gcd(100, 25, Result2),
    assertion(Result2 == 25),
    gcd(17, 13, Result3),
    assertion(Result3 == 1).

test(least_common_multiple) :-
    lcm(6, 4, Result1),
    assertion(Result1 == 12),
    lcm(21, 6, Result2),
    assertion(Result2 == 42),
    lcm(7, 3, Result3),
    assertion(Result3 == 21).

:- end_tests(numerical_suite).