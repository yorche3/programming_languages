-module(numerical).

-export([fibonacci/1, factorial/1, gcd/2, lcm/2]).

fibonacci(N) ->
  if
    N < 0 ->
      -1;
    N < 2 ->
      N;
    N >1 ->
      fibonacci_loop(N, 0, 1)
  end.

fibonacci_loop(N, Acc2, Acc1) ->
  if
    N == 2 ->
      Acc1 + Acc2;
    true ->
      fibonacci_loop(N - 1, Acc1, Acc1 + Acc2)
  end.

factorial(N) ->
  if
    N < 0 ->
      -1;
    true ->
      factorial_loop(N, 1)
  end.

factorial_loop(N, Acc) ->
  if
    N == 1 ->
      Acc;
    true ->
      factorial_loop(N - 1, N * Acc)
  end.

gcd(A, B) -> 
  if
    B == 0 ->
      A;
    true ->
      gcd(B, A rem B)
  end.

lcm(A, B) ->
  (A div gcd(A, B)) * B.