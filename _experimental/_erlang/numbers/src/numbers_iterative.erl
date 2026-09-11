-module(numbers_iterative).
-export([fibonacci/1, factorial/1, sum_numbers/1]).

fibonacci(N) ->
    fibonacci_iter(N, 0, 1).

fibonacci_iter(N, _, _) when N =< 1 ->
    N;
fibonacci_iter(N, Acc2, Acc1) when N =:= 2 ->
    Acc1 + Acc2;
fibonacci_iter(N, Acc2, Acc1) ->
    fibonacci_iter(N - 1, Acc1, Acc1 + Acc2).

factorial(N) ->
    factorial_iter(N, 1).

factorial_iter(N, Accumulator) when N =< 1 ->
    Accumulator;
factorial_iter(N, Accumulator) ->
    factorial_iter(N - 1, N * Accumulator).

sum_numbers(N) ->
    sum_numbers_iter(N, 0).

sum_numbers_iter(N, Accumulator) when N =< 0 ->
    Accumulator;
sum_numbers_iter(N, Accumulator) ->
    sum_numbers_iter(N - 1, N + Accumulator).