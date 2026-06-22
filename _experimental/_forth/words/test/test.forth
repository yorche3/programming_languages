: assert-equals ( actual expected -- )
  2dup = if
    2drop
  else
    ." Assertion Failed!" cr
    ." Expected: " . cr
    ." Actual:   " . cr
    abort
  then
;

: assert-compare ( actual-str expected-str -- )
  2over 2over
  compare 0= if
    2drop 
  else
    ." Assertion failed!" cr
    ." Expected: " type cr
    ." Actual:   " type cr
    abort
  then
;