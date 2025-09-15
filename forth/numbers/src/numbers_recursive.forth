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

: fibonacci ( N -- F )
  dup 0 <= if
    drop
    0
  else
    dup 1 = if
        drop
        1
    else
        dup 2 - recurse
        swap 1 - recurse
        +
    then
  then
;

: factorial ( N -- F )
  dup 1 <= if
    drop
    1
  else
    dup 1 - recurse
    * 
  then
;

: sum-numbers ( N -- S )
  dup 0 <= if
    drop
    0
  else
    dup 1 - recurse
    + 
  then
;