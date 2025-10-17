unit module Numerical;

sub fibonacci(Int $N) is export {
	return -1 if $N < 0;
	return $N if $N < 2;
	my $acc1 = 0;
	my $acc2 = 1;
	for 2 .. $N -> $i {
		my $temp = $acc1;
		$acc1 = $acc1 + $acc2;
		$acc2 = $temp;
	}
	return $acc1+$acc2;
}

sub factorial(Int $N) is export {
	return -1 if $N < 0;
	return 1 if $N <= 1;
	my $acc = 1;
	for 1 .. $N -> $i {
		$acc *= $i;
	}
	return $acc;
}

sub gcd(Int $A, Int $B) is export {
	return $A if $B == 0;
	return gcd($B, $A % $B);
}

sub lcm(Int $A, Int $B) is export {
	return ($A / gcd($A, $B)) * $B;
}