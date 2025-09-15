module numbers_recursive
contains

  ! Recursive Fibonacci
  recursive function fibonacci(N) result(res)
    integer, intent(in) :: N
    integer :: res
    if (N <= 1) then
      res = N
    else
      res = fibonacci(N - 1) + fibonacci(N - 2)
    end if
  end function fibonacci

  ! Recursive factorial
  recursive function factorial(N) result(res)
    integer, intent(in) :: N
    integer :: res
    if (N == 1) then
      res = 1
    else
      res = N * factorial(N - 1)
    end if
  end function factorial

  ! Recursive sum of first N numbers
  recursive function sum_numbers(N) result(res)
    integer, intent(in) :: N
    integer :: res
    if (N == 0) then
      res = 0
    else
      res = N + sum_numbers(N - 1)
    end if
  end function sum_numbers

end module numbers_recursive