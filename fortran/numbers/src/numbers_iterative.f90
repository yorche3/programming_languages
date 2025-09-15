module numbers_iterative
contains

  function fibonacci(N) result(res)
    integer, intent(in) :: N
    integer :: res
    res = fibonacci_iter(N, 0, 1)
  end function fibonacci

  recursive function fibonacci_iter(N, Acc2, Acc1) result(res)
    integer, intent(in) :: N, Acc2, Acc1
    integer :: res
    if (N <= 1) then
      res = N
    else if (N == 2) then
      res = Acc1 + Acc2
    else
      res = fibonacci_iter(N - 1, Acc1, Acc1 + Acc2)
    end if
  end function fibonacci_iter

  function factorial(N) result(res)
    integer, intent(in) :: N
    res = factorial_iter(N, 1)
  end function factorial

  recursive function factorial_iter(N, Accumulator) result(res)
    integer, intent(in) :: N, Accumulator
    integer :: res
    if (N == 1) then
      res = Accumulator
    else
      res = factorial_iter(N - 1, N * Accumulator)
    end if
  end function factorial_iter

  function sum_numbers(N) result(res)
    integer, intent(in) :: N
    res = sum_numbers_iter(N, 0)
  end function sum_numbers

  recursive function sum_numbers_iter(N, Accumulator) result(res)
    integer, intent(in) :: N, Accumulator
    integer :: res
    if (N == 0) then
      res = Accumulator
    else
      res = sum_numbers_iter(N - 1, N + Accumulator)
    end if
  end function sum_numbers_iter

end module numbers_iterative