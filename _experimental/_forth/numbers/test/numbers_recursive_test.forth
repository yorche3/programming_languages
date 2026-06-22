include ../src/numbers_recursive.forth

: assert ( flag -- )
  0 = if
    cr ." Assertion failed!" cr
    abort
  then
;

: test-fibonacci ( -- )
  5 fibonacci 5 = assert
;

: test-factorial ( -- )
  5 factorial 120 = assert
;

: test-sum-numbers ( -- )
  5 sum-numbers 15 = assert
;

: run-tests-recursive ( -- )
  test-fibonacci
  test-factorial
  test-sum-numbers
  cr ." All recursive tests passed" cr
;