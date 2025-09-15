unit module NumbersRecursive;

sub fibonacci(Int $N) is export {
    if $N <= 0 { return 0 }
    if $N == 1 { return 1 }
    return fibonacci($N - 1) + fibonacci($N - 2);
}

sub factorial(Int $N) is export {
    if $N <= 1 { return 1 }
    return $N * factorial($N - 1);
}

sub sum_numbers(Int $N) is export {
    if $N <= 0 { return 0 }
    return $N + sum_numbers($N - 1);
}