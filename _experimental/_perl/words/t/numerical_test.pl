#!/usr/bin/perl
use strict;
use warnings;

require './lib/numerical.pl';

use Test::More tests => 12;

is(fibonacci(-3), -1, 'fibonacci of negative number');
is(fibonacci(10), 55, 'fibonacci of 10');
is(fibonacci(15), 610, 'fibonacci of 15');

is(factorial(-3), -1, 'factorial of negative number');
is(factorial(5), 120, 'factorial of 5');
is(factorial(10), 3628800, 'factorial of 10');

is(gcd(48, 18), 6, 'gcd of 48 and 18');
is(gcd(100, 25), 25, 'gcd of 100 and 25');
is(gcd(17, 13), 1, 'gcd of 17 and 13');

is(lcm(6, 4), 12, 'lcm of 6 and 4');
is(lcm(21, 6), 42, 'lcm of 21 and 6');
is(lcm(7, 3), 21, 'lcm of 7 and 3');