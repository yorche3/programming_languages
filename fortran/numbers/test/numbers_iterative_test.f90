program test_iterative
  use funit
  use numbers_iterative
  implicit none

  @test
  subroutine test_fibonacci()
    call assertEqual(fibonacci(5), 5)
  end subroutine

  @test
  subroutine test_factorial()
    call assertEqual(factorial(5), 120)
  end subroutine

  @test
  subroutine test_sum_numbers()
    call assertEqual(sum_numbers(5), 15)
  end subroutine

end program test_iterative