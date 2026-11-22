variable test-count
variable passed-count
variable failed-count

create label 128 allot
variable label-len

: init-tests ( -- )
    0 test-count !
    0 passed-count !
    0 failed-count !
    0 label-len !
;

: set-label ( c-addr u -- )
    dup label-len !
    label swap move
;

: append-label ( c-addr u -- )
    >r
    label label-len @ +
    r@ move
    r> label-len +!
;

: assert-equals ( actual expected -- )
    test-count @ 1 + test-count !
    2dup = if
        2drop
        passed-count @ 1 + passed-count !
    else
        failed-count @ 1 + failed-count !
        cr s"   [FAIL] " type
        label-len @ 0> if label label-len @ type s" : " type then
        s" Expected: " type . s" but got: " type . cr
    then
;

: test-report ( -- )
    cr
    s" tests runned " type test-count @ .
    cr
    s" passed " type passed-count @ .
    cr
    s" failed " type failed-count @ .
    cr
    failed-count @ 0> if 1 (bye) then
;
