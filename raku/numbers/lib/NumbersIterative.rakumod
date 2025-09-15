unit module NumbersIterative;

sub fibonacci(Int $N) is export {
    return fibonacci_iter($N, 0, 1);
}

sub fibonacci_iter(Int $N, $Acc2, $Acc1) {
    if $N <= 0 { return $Acc2 }
    if $N <= 1 { return $Acc1 }
    return fibonacci_iter($N - 1, $Acc1, $Acc1 + $Acc2);
}

sub factorial(Int $N) is export {
    return factorial_iter($N, 1);
}

sub factorial_iter(Int $N, $Acc) {
    if $N <= 1 { return $Acc }
    return factorial_iter($N - 1, $N * $Acc);
}

sub sum_numbers(Int $N) is export {
    return sum_numbers_iter($N, 0);
}

sub sum_numbers_iter(Int $N, $Acc) {
    if $N <= 0 { return $Acc }
    return sum_numbers_iter($N - 1, $N + $Acc);
}