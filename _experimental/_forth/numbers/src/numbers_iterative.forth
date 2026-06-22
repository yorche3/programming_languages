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

: fibonacci-iter ( N acc2 acc1 -- F )
	2 pick 1 <= if
		drop drop
	else
		2 pick 2 = if
			+ nip
		else
			rot
			dup 1 - nip
			swap rot
			over +
			recurse
		then
  then ;

: fibonacci ( N -- F )
  0 1 fibonacci-iter
;

: factorial-iter ( N acc -- F )
  1 pick 1 <= if
    nip
  else
    over 1 -
    rot rot
    *
    recurse
  then
;

: factorial ( N -- F )
  1 factorial-iter
;

: sum-numbers-iter ( N acc -- S )
  1 pick 0 <= if
    nip
  else
    over 1 -
    rot rot
    + 
    recurse
  then
;

: sum-numbers ( N acc -- S ) 
	0 sum-numbers-iter
;
