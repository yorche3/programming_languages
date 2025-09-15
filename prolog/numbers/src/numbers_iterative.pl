fibonacci(N, Result) :-
    fibonacci_iter(N, 0, 1, Result), !.

fibonacci_iter(0, Acc2, _, Acc2).
fibonacci_iter(N, Acc2, Acc1, Result) :-
    N =< 2,
    Result is Acc1 + Acc2.
fibonacci_iter(N, Acc2, Acc1, Result) :-
    N1 is N - 1,
    fibonacci_iter(N1, Acc1, Acc1 + Acc2, Result), !.

factorial(N, Result) :-
    factorial_iter(N, 1, Result), !.

factorial_iter(N, Acc, Result) :-
    N =< 1,
    Result is Acc.
factorial_iter(N, Acc, Result) :-
    N1 is N - 1,
    factorial_iter(N1, Acc * N, Result), !.

sum_numbers(N, Result) :-
    sum_numbers_iter(N, 0, Result), !.

sum_numbers_iter(N, Acc, Result) :-
    N =< 0,
    Result is Acc.
sum_numbers_iter(N, Acc, Result) :-
    N1 is N - 1,
    sum_numbers_iter(N1, Acc + N, Result), !.