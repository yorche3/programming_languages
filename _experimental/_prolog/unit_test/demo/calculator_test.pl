:- use_module(library(plunit)).
:- consult('calculator.pl').

:- begin_tests(calculator_tests).
test(add) :-
    add(2, 3, Sum),
    assertion(Sum == 15).

test(subtract) :-
    subtract(5, 3, Result),
    assertion(Result == 2).

:- end_tests(calculator_tests).

:- initialization(run_tests(calculator_tests), main).