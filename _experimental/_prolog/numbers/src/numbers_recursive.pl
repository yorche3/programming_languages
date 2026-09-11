fibonacci(0, 0) :- !.
fibonacci(1, 1) :- !.
fibonacci(N, Result) :-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    fibonacci(N1, F1),
    fibonacci(N2, F2),
    Result is F1 + F2.

factorial(0, 1) :- !.
factorial(N, Result) :-
    N > 0,
    N1 is N -1,
    factorial(N1, R1),
    Result is N * R1.

sum_numbers(0, 0) :- !.
sum_numbers(N, Sum) :-
    N > 0,
    N1 is N - 1,
    sum_numbers(N1, Sum1),
    Sum is Sum1 + N.