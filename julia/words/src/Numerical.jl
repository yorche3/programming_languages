#!/usr/bin/julia

module Numerical
export fibonacci, factorialy, gcdy, lcmy

function fibonacci(n::Int) :: Int
  if n < 0 
    return -1
  elseif n <= 1 
    return n 
  end
  acc1 = 1
  acc2 = 0
  for _ in 3:n
    acc2, acc1 = acc1, acc1 + acc2
  end
  return acc1 + acc2
end

function factorialy(n::Int) :: Int
  if n < 0 
    return -1
  end
  acc = 1
  while n > 1
    acc *= n
    n -= 1
  end
  return acc
end

function gcdy(a::Int, b::Int) :: Int
  while b != 0
    a, b = b, a % b
  end
  return a
end

lcmy(a::Int, b::Int) :: Int = (a * b) ÷ Base.gcd(a, b)

end
