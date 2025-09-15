:- use_module(library(plunit)).
:- consult('../src/numbers_recursive.pl').

:- begin_tests(recursive_tests).
test(fibonacci) :-
    fibonacci(5, Result),
    assertion(Result == 5).

test(factorial) :-
    factorial(5, Result),
    assertion(Result == 120).

test(sum_numbers) :-
    sum_numbers(5, Sum),
    assertion(Sum == 15).

:- end_tests(recursive_tests).

:- initialization(run_tests(recursive_tests), main).