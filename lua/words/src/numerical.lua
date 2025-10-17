local numerical = {}

function numerical.fibonacci(n)
	local function fibonacci_calc(n, acc2, acc1)
		if n < 0 then
			return -1
		elseif n < 2 then
			return n
		elseif n == 2 then
			return acc1 + acc2
		else
			return fibonacci_calc(n - 1, acc1, acc1 + acc2)
		end
	end
	return fibonacci_calc(n, 0, 1)
end

function numerical.factorial(n)
	local function factorial_calc(n, acc)
		if n < 0 then
			return -1
		elseif n <= 1 then
			return acc
		else
			return factorial_calc(n - 1, n * acc)
		end
	end
	return factorial_calc(n, 1)
end

function numerical.gcd(a, b)
	if b == 0 then
		return a
	else
		return numerical.gcd(b, a % b)
	end
end

function numerical.lcm(a, b)
	return (a / numerical.gcd(a, b)) * b
end
return numerical