#!/usr/bin/perl
use strict;
use warnings;

require './calculator.pl';

use Test::More tests => 2;

is(add(2, 3), 5, 'add 2 + 3');

is(subtract(5, 3), 2, 'subtract 5 - 3');

print "All tests passed.\n";