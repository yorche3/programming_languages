include numbers_iterative_test.forth
include numbers_recursive_test.forth

: run-all-tests ( -- )
  cr ." Running Recursive Tests..." cr
  run-tests-recursive
  cr ." Running Iterative Tests..." cr
  run-tests-iterative
  cr ." All tests completed." cr
;

run-all-tests
bye