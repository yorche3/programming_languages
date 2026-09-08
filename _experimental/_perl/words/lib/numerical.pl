#!/usr/bin/perl
use strict;
use warnings;

sub fibonacci {
	my ($n) = @_;
  if ($n < 0) {
    return -1;
  } elsif ($n < 2) {
    return $n;
  }
  my $acc1 = 1;
  my $acc2 = 0;
  my $temp;
  while ($n > 2) {
		$temp = $acc1;
		$acc1 = $acc1 + $acc2;
		$acc2 = $temp;
		$n--;
	}
	return $acc1 + $acc2;
}

sub factorial {
	my ($n) = @_;
  if ($n < 0) {
    return -1;
  }
	my $acc = 1;
	while ($n > 1) {
		$acc = $acc * $n;
		$n--;
	}
	return $acc;
}

sub gcd {
	my ($a, $b) = @_;
	while ($b > 0) {
		my $temp = $b;
		$b = $a % $b;
		$a = $temp;
	}
	return $a;
}

sub lcm {
	my ($a, $b) = @_;
	return ($a / gcd($a, $b)) * $b;
}

1;