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
variable aux

: reverse-string ( addr len -- addr' len ) \ str := (addr, len)
	2dup swap \ S= addr len addr len -> S= addr len len addr
	+ 1 - \ S= addr len 'end-addr := len + addr - 1 => and char address';
	j-var ! \ save last character in j-var -> S= addr len
	>r \ save on return stack S= addr
	dup i-var ! \ duplicate addr to iterate with i -> S= addr
	begin
		j-var @ i-var @ > \ while i < j
	while
		i-var @ c@ aux ! \ aux = str[i-var]
		j-var @ c@ i-var @ c! \ str[i-var] = str[j-var]
		aux @ j-var @ c! \ str[j-var] = aux
		j-var @ 1 - j-var ! \ decrement j-var
		i-var @ 1 + i-var ! \ increment i-var
	repeat
	r>
;

variable buffer
: create-buffer ( n -- addr )
  allocate
	drop
  buffer !
;

: is-whitespace ( c -- flag )
  dup 9 = if drop 1 exit then   \ tab
  dup 10 = if drop 1 exit then  \ newline
  dup 13 = if drop 1 exit then  \ carriage return
  dup 32 = if drop 1 exit then  \ space
  drop 0                        \ not whitespace
;

variable str
variable len
: remove-whitespaces ( addr len -- )
	>r str !
	r@ create-buffer
	0 len !
	r@ 0 do
		str @ i +
		c@ is-whitespace
		0 = if
			str @ i + c@
			buffer @ len @ +
			c!
			len @ 1 + len !
		then
	loop
	r> drop
	buffer @ len @
;

: is-palindrome ( addr len -- boolean )
	dup 1 <= if
		drop drop
		-1
	else
		remove-whitespaces
		+ 1 - j-var !
		buffer @ i-var !
		-1
		begin
			j-var @ i-var @ >
			dup 0 <>
			and
		while
			drop
			i-var @ c@ j-var @ c@
			j-var @ 1 - j-var !
			i-var @ 1 + i-var !
			=
		repeat
	then
;

variable lps
: print-array ( n -- )
  0 do
		i lps + c@ . \ get lps[i]
  loop
;

\ Define the general-purpose array creation word
: init-array ( u -- )
	dump-stack
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
: kmp-search ( addr len addr len -- boolean )
	len-txt !
	txt !
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

: is-substring ( addr len addr len -- boolean )
	kmp-search lps
;