call 'fibonacci.rexx' 5
fib_result = result
if fib_result = 5 then
   say "Fibonacci... [OK]"
else
   say "Fibonacci... [FAILED]"

call 'factorial.rexx' 5
fact_result = result
if fact_result = 120 then
   say "Factorial... [OK]"
else
   say "Factorial... [FAILED]"

call 'sum_numbers.rexx' 5
sum_result = result
if sum_result = 15 then
   say "Sum_Numbers... [OK]"
else
   say "Sum_Numbers... [FAILED]"