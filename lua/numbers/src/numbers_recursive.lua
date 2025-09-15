local numbers_recursive = {}

function numbers_recursive.fibonacci(n)
  if n <= 0 then
    return 0
  elseif n == 1 then
    return 1
  else
    return numbers_recursive.fibonacci(n - 1) + numbers_recursive.fibonacci(n - 2)
  end
end

function numbers_recursive.factorial(n)
  if n == 0 then
    return 1
  else
    return n * numbers_recursive.factorial(n - 1)
  end
end

function numbers_recursive.sum_numbers(n)
  if n <= 0 then
    return 0
  else
    return n + numbers_recursive.sum_numbers(n - 1)
  end
end
return numbers_recursive