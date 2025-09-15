import numbers_recursive

fn test_fibonacci() {
    assert numbers_recursive.fibonacci(5) == 5
}

fn test_factorial() {
    assert numbers_recursive.factorial(5) == 120
}

fn test_sum_numbers() {
    assert numbers_recursive.sum_numbers(5) == 15
}