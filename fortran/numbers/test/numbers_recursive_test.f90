module numbers_recursive_test
  use funit
  use numbers_recursive
  implicit none

contains
  @test
  subroutine test_fibonacci()
    @assertEqual(fibonacci(5), 5)
  end subroutine test_fibonacci

  @test
  subroutine test_factorial()
    @assertEqual(factorial(5), 120)
  end subroutine test_fibonacci

  @test
  subroutine test_sum_numbers()
    @assertEqual(sum_numbers(5), 15)
  end subroutine test_fibonacci

end module numbers_recursive_test