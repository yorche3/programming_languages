local numbers_iterative = {}

function numbers_iterative.fibonacci(n)
    local function fibonacci_iter(n, acc2, acc1)
        if n <= 0 then
            return acc2
        elseif n <= 2 then
            return acc1 + acc2
        else
            return fibonacci_iter(n - 1, acc1, acc1 + acc2)
        end
    end

    -- Initialize with base values: 0, 1
    return fibonacci_iter(n, 0, 1)
end

function numbers_iterative.factorial(n)
    local function factorial_iter(n, acc)
        if n <= 1 then
            return acc
        else
            return factorial_iter(n - 1, n * acc)
        end
    end

    return factorial_iter(n, 1)
end

function numbers_iterative.sum_numbers(n)
    local function sum_numbers_iter(n, acc)
        if n <= 0 then
            return acc
        else
            return sum_numbers_iter(n - 1, n + acc)
        end
    end

    return sum_numbers_iter(n, 0)
end
return numbers_iterative