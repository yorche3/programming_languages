#!/usr/bin/perl
use strict;
use warnings;

sub reverse_string {
	my ($s) = @_;
	my $reversed = "";
	for my $char (split //, $s) {
		$reversed = $char . $reversed;
	}
	return $reversed;
}

sub is_palindrome {
	my ($s) = @_;
	my $cleaned_str = $s;
	$cleaned_str =~ s/\s+//g;
	my $j = length($cleaned_str) - 1;
	my $i = 0;
	while ($i < $j) {
		if (substr($cleaned_str, $i, 1) ne substr($cleaned_str, $j, 1)) {
			return 0;
		}
		$i++;
		$j--;
	}
	return 1;
}

sub compute_lps_array {
	my ($pat) = @_;
	my $len_pat = length($pat);
	my @lps = [0] x $len_pat;
	my $i = 1;
	my $len = 0;
	while ($i < $len_pat) {
		if (substr($pat, $i, 1) eq substr($pat, $len, 1)) {
			$len++;
			$lps[$i] = $len;
			$i++;
		} else {
			if ($len > 0) {
				$len = $lps[$len - 1];
			} else {
				$lps[$i] = 0;
				$i++;
			}
		}
	}
	return @lps;
}

sub kmp_search {
	my ($sub, $txt) = @_;
	my $len_sub = length($sub);
	my $len_txt = length($txt);
	if ($len_sub == 0) {
		return 1;
	} elsif ($len_sub > $len_txt) {
		return 0;
	}
	my @lps = compute_lps_array($sub);
	my $i = 0;
	my $j = 0;
	while ($i < $len_txt) {
		if (substr($txt, $i, 1) eq substr($sub, $j, 1)) {
			$i++;
			$j++;
			if ($j == $len_sub) {
				return 1;
			}
		} else {
			if ($j > 0) {
				$j = $lps[$j - 1];
			} else {
				$i++;
			}
		}
	}
	return 0;
}

sub max {
	my ($a, $b) = @_;
	if ($a > $b) {
		return $a;
	} else {
		return $b;
	}
}

sub lcs {
	my ($str1, $str2) = @_;
	my $len1 = length($str1);
	my $len2 = length($str2);
	my @dp;
	for (my $i = 0; $i < $len1 + 1; $i++) {
    for (my $j = 0; $j < $len2 + 1; $j++) {
      $dp[$i][$j] = 0;
    }
	}
	for (my $i = 1; $i <= $len1; $i++) {
		for (my $j = 1; $j <= $len2; $j++) {
			if (substr($str1, $i - 1, 1) eq substr($str2, $j - 1, 1)) {
				$dp[$i][$j] = $dp[$i - 1][$j - 1] + 1;
			} else {
				$dp[$i][$j] = max($dp[$i - 1][$j], $dp[$i][$j - 1]);
			}
		}
	}
	return $dp[$len1][$len2];
}

1;