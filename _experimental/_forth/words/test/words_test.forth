include ../src/words.forth
include test.forth

: test-reverse-string ( -- )
	S" hello" reverse-string S" olleh" assert-compare
	S" a" reverse-string S" a" assert-compare
	S" " reverse-string S" " assert-compare
	drop drop drop drop drop drop
;

: test-is-palindrome ( -- )
	s" racecar" is-palindrome -1 assert-equals
	s" level" is-palindrome -1 assert-equals
	s" hello" is-palindrome 0 assert-equals
	s" a" is-palindrome -1 assert-equals
	s" " is-palindrome -1 assert-equals
;

: test-is-substring ( -- )
	cr ." Is Substring starting..." cr
	s" test" s" this is a test" is-substring -1 assert-equals
	s" not" s" this is a test" is-substring 0 assert-equals
	s" " s" any string" is-substring -1 assert-equals
	s" abc" s" abc" is-substring -1 assert-equals
	s" abc" s" ab" is-substring 0 assert-equals
	cr ." Is Substring finished..." cr
;

: run-words-tests ( -- )
	test-reverse-string
	test-is-palindrome
	test-is-substring
	cr ." All words tests passed" cr
;