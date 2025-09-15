#!/usr/bin/perl
use strict;
use warnings;

require './lib/numbers_recursive.pl';

use Test::More tests => 2;

is(fibonacci(5), 5, 'fibonacci of 5');

is(factorial(5), 120, 'factorial of 5');

is(sum_numbers(5), 15, 'sum of first 5 numbers');

print "All tests passed.\n";