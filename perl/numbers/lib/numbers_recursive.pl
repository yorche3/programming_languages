#!/usr/bin/perl
use strict;
use warnings;

sub fibonacci {
    my ($N) = @_;
    if ($N <= 0) {
        return 0;
    } elsif ($N == 1) {
        return 1;
    } else {
        return fibonacci($N - 1) + fibonacci($N - 2);
    }
}

sub factorial {
    my ($N) = @_;
    if ($N <= 1) {
        return 1;
    } else {
        return $N * factorial($N - 1);
    }
}

sub sum_numbers {
    my ($N) = @_;
    if ($N <= 0) {
        return 0;
    } else {
        return $N + sum_numbers($N - 1);
    }
}

1; 