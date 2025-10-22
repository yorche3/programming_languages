: dump-stack ( -- )
	depth 0 = if
  	." Stack is empty." cr
  else
    ." Stack (" depth ." items):" cr
    0 do
      i pick . cr
    loop
  then
;
variable i-var
variable j-var
variable len
\ new code

variable lps
: print-array ( n -- )
  0 do
		i lps + c@ . \ get lps[i]
  loop
;

\ Define the general-purpose array creation word
: init-array ( u -- )
  create dup , cells allot
	does>
		u< 0= -24 and throw ( invalid numeric argument )
		cell+
		swap cells +
;

variable array
variable sub
variable len-sub
: compute-lps-array ( addr len -- array )
	len-sub !
	sub !
	len-sub @ init-array lps
	drop
	1 i-var !
	0 len !
	begin
		i-var @ len-sub @ <
	while
		sub @ i-var @ + c@
		sub @ len @ + c@
		= if
			len @ 1 + dup len !
			i-var @ lps + !
			i-var @ 1 + i-var !
		else
			len @ 0 = if
				0 i-var @ lps + !
				i-var @ 1 + i-var !
			else
				len @ 1 - lps + c@
				len !
			then
		then
	repeat
;

variable txt
variable len-txt
variable found
: is-substring ( addr len addr len -- boolean )
	>r >r
	dup 0 = if
		drop drop
		r> r> drop drop
		-1
	exit
	then
	r> r>
	2 pick over
	> if
		drop drop drop drop
		0
	exit
	then
	>r >r
	compute-lps-array
	r> txt !
	r> len-txt !
	0 i-var !
	0 j-var !
	0 found !
	begin
		i-var @ len-txt @ <
		found @ 0 =
		and
	while
		txt @ i-var @ + c@
		sub @ j-var @ + c@
		= if
			i-var @ 1 + i-var !
			j-var @ 1 + j-var !
			j-var @ len-sub @ = if
				-1 found !
			then
		else
			j-var @ 0 = if
				i-var @ 1 + i-var !
			else
				j-var @ 1 - lps + c@
				j-var !
			then
		then
	repeat
	found @
;

s" test" s" this is a test" is-substring lps . cr
bye