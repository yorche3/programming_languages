unit module Words;

sub reverse_string(Str $s) is export {
	my $reversed = Buf.new;
	for $s.comb -> $ch {
		$reversed.prepend($ch.encode('utf-8'));
		say $reversed;
	}
	return $reversed.decode('utf-8');
}

sub is_palindrome(Str $st) is export {
	if $st.chars <= 1 {
		return True;
	}
	my $cleanedStr = $st.subst(rx/\s+/, '', :g);
	my $len = $cleanedStr.chars;
	for 0 .. ($len div 2) -> $i {
		if $cleanedStr.substr($i,1) ne $cleanedStr.substr($len-$i-1,1) {
			return False;
		}
	}
	return True;
}

sub compute_lps_array(Str $patt) {
	my $len_patt = $patt.chars;
	my @lps = (0 xx $len_patt);
	my $length = 0;
	my $i = 1;
	while $i < $len_patt {
		if $patt.substr($i,1) eq $patt.substr($length,1) {
			$length++;
			@lps[$i] = $length;
			$i++;
		} else {
			if $length != 0 {
				$length = @lps[$length - 1];
			} else {
				@lps[$i] = 0;
				$i++;
			}
		}
	}
	return @lps;
}

sub kmp_search(Str $sub, Str $s) is export {
	my $len_sub = $sub.chars;
	my $len_s = $s.chars;
	return True if $len_sub == 0;
	return False if $len_sub > $len_s;
	my @lps = compute_lps_array($sub);
	my $i = 0;
	my $j = 0;
	while $i < $len_s {
		if $sub.substr($j,1) eq $s.substr($i,1) {
			$i++;
			$j++;
			if $j == $len_sub {
				return True;
			}
		} else {
			if $j != 0 {
				$j = @lps[$j - 1];
			} else {
				$i++;
			}
		}
	}
	return False;
}

sub max(Int $a, Int $b) is export {
	return $a > $b ?? $a !! $b;
}

sub lcs(Str $str1, Str $str2) is export {
	my $len1 = $str1.chars;
	my $len2 = $str2.chars;
	my @dp = ([0 xx ($len2 + 1)] xx ($len1 + 1));
	for 1 .. $len1 -> $i {
		for 1 .. $len2 -> $j {
			if $str1.substr($i - 1, 1) eq $str2.substr($j - 1, 1) {
				@dp[$i][$j] = @dp[$i - 1][$j - 1] + 1;
			} else {
				@dp[$i][$j] = max(@dp[$i - 1][$j], @dp[$i][$j - 1]);
			}
		}
	}
	return @dp[$len1][$len2];
}