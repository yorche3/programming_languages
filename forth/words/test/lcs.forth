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
variable len1
variable len2
variable dp
variable len
variable str1
variable str2

: print-array ( n -- )
	0 do
		i dp + c@ . \ get dp[i]
	loop
;

: init-array ( u -- )
	create dup , cells allot
 	does>
 		u< 0= -24 and throw ( invalid numeric argument )
 		cell+
 		swap cells +
;

: init-dp-array ( -- )
	len2 @ 1+ len1 @ 1+ * 
	dup len !
	init-array dp
	drop
;

: max ( a b -- max-val )
	2dup > if
		drop
	else
		swap drop
	then
;

: lcs ( addr1 len1 addr2 len2 -- length )
	len2 !
	str2 !
	len1 !
	str1 !
	init-dp-array
	len @
	dup 0 do
		0 i dp + !
	loop
	>r
	1 i-var !
	1 j-var !
	begin
		i-var @ len1 @ 1+ <
	while
		j-var @ len2 @ 1 + = if
			i-var @ 1 + i-var !
			1 j-var !
		else
			i-var @ 1 - str1 @ + c@
			j-var @ 1 - str2 @ + c@
			= if
				i-var @ 1 - len2 @ 1 + *
				j-var @ 1 - +
				dp + c@
				1+
				i-var @ len2 @ 1 + * j-var @ + dp + !
			else
				i-var @ 1 - len2 @ 1 + *
				j-var @ + dp + c@
				i-var @ len2 @ 1 + *
				j-var @ 1 - + dp + c@
				max
				i-var @ len2 @ 1 + * j-var @ + dp + !
			then
			j-var @ 1 + j-var !
		then
	repeat
	r> drop
	len1 @ len2 @ 1 + * len2 @ + dp + c@
;

s" AGGTAB" s" GXTXAYB" lcs dp . cr
s" ABC" s" ABC" lcs dp . cr
s" ABC" s" DEF" lcs dp . cr
s" " s" ABC" lcs dp . cr
s" ABC" s" " lcs dp . cr
bye