#!/usr/bin/perl

use diagnostics;
use strict;
use warnings;
use Test::More qw( no_plan );

do './basic_math.pl';

is(hello(), 'hello', 'test_hello');
is(min(), 2, 'test_min');
is(max(), 3.4, 'test_max');
