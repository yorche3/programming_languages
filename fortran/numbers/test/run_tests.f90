program run_all_tests
  use funit
  implicit none

  call run_tests("tests/numbers_recursive_test.f90")
  call run_tests("tests/numbers_iterative_test.f90")
end program run_all_tests