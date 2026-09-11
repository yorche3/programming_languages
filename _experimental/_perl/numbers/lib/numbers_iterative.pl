#!/usr/bin/perl
use strict;
use warnings;

sub fibonacci {
    my ($N) = @_;
    return fibonacci_iter($N, 0, 1);
}

sub fibonacci_iter {
    my ($N, $acc2, $acc1) = @_;
    if ($N < 1) {
        return $acc2;
    } elsif ($N <= 2) {
        return $acc1 + $acc2;
    } else {
        return fibonacci_iter($N - 1, $acc1, $acc1 + $acc2);
    }
}

sub factorial {
    my ($N) = @_;
    return factorial_iter($N, 1);
}

sub factorial_iter {
    my ($N, $acc) = @_;
    if ($N <= 1) {
        return $acc;
    } else {
        return factorial_iter($N - 1, $N * $acc);
    }
}

sub sum_numbers {
    my ($N) = @_;
    return sum_numbers_iter($N, 0);
}

sub sum_numbers_iter {
    my ($N, $acc) = @_;
    if ($N <= 0) {
        return $acc;
    } else {
        return sum_numbers_iter($N - 1, $N + $acc);
    }
}

1;