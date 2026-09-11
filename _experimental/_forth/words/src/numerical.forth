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


variable I
variable AUX

: fibonacci ( N -- FN )
  dup 0 < if
    drop
    -1
  else
    dup 0 = if
      drop
      1
      dump-stack
    else
      0 swap 1 swap
			begin
				dup 2 >
			while
				I !
				dup
				AUX !
				+
				AUX @ swap
				I @
				1 -
			repeat
			drop
			+
		then
	then
;

: factorial ( N -- NF )
  dup 0 < if
		drop
		-1
	else
		1
		swap
		begin
			dup 1 >
		while
			swap
			over *
			swap
			1 -
		repeat
		drop
	then
;

: gcd ( A B -- GCD )
	dup 0 <= if
		drop
	else
		begin
			dup 0 >
		while
			dup AUX !
			mod
			AUX @
			swap
		repeat
		drop
	then
;

: lcm ( A B -- LCM )
	swap over over
	gcd /
	swap *
;
