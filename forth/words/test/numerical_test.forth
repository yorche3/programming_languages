include ../src/numerical.forth
include test.forth

: test-fibonacci ( -- )
	-3 fibonacci -1 assert-equals
  10 fibonacci 55 assert-equals
  15 fibonacci 610 assert-equals
  cr ." [OK] fibonacci" cr
;

: test-factorial ( -- )
  -3 factorial -1 assert-equals
  5 factorial 120 assert-equals
  10 factorial 3628800 assert-equals
  cr ." [OK] factorial" cr
;

: test-gcd ( -- )
  18 48 gcd 6 assert-equals
  25 100 gcd 25 assert-equals
  13 17 gcd 1 assert-equals
  cr ." [OK] gcd" cr
;

: test-lcm ( -- )
  6 4 lcm 12 assert-equals
  21 6 lcm 42 assert-equals
  7 3 lcm 21 assert-equals
  cr ." [OK] lcm" cr
;

: run-numerical-tests ( -- )
  test-fibonacci
  test-factorial
  test-gcd
  test-lcm
  cr ." All numerical tests passed" cr
;