include words_test.forth

: run-all-tests ( -- )
  cr ." Running Words Tests..." cr
  run-words-tests
  cr ." All tests completed." cr
;

run-all-tests
bye