namespace eval words {
	namespace export reverse_string is_palindrome kmp_search lcs

	proc reverse_string {str} {
		set len [string length $str]
		set reversed ""
		for {set i [expr {$len - 1}]} {$i >= 0} {incr i -1} {
			set ch [string index $str $i]
			append reversed $ch
		}
		return $reversed
	}

	proc is_palindrome {str} {
		regsub -all {\s} $str "" cleaned_str
		set len [string length $cleaned_str]
		for {set i 0} {$i < [expr {$len / 2}]} {incr i} {
			if {[string index $cleaned_str $i] != [string index $cleaned_str [expr {$len - 1 - $i}]]} {
				return false
			}
		}
		return true
	}

	proc compute_lps_array {patt} {
		set len_patt [string length $patt]
		array set lps {}
		set i 1
		set len 0
		set lps(0) 0
		while {$i < $len_patt} {
			if {[string index $patt $i] == [string index $patt $len]} {
				incr len
				set lps($i) $len
				incr i
			} else {
				if {$len > 0} {
					set len $lps([expr {$len - 1}])
				} else {
					set lps($i) 0
					incr i
				}
			}
		}
		return [array get lps]
	}

	proc kmp_search {sub str} {
		set len_sub [string length $sub]
		set len_str [string length $str]
		if {$len_sub == 0} {
			return true
		} elseif {$len_sub > $len_str} {
			return false
		}
		array set lps [compute_lps_array $sub]
		set i 0
		set j 0
		while {$i < $len_str} {
			if {[string index $str $i] == [string index $sub $j]} {
				incr i
				incr j
				if {$j == $len_sub} {
					return true
				}
			} else {
				if {$j > 0} {
					set j $lps([expr {$j - 1}])
				} else {
					incr i
				}
			}
		}
		return false
	}

	proc zeros_array {n m} {
		array set arr {}
		for {set i 0} {$i < $n} {incr i} {
			for {set j 0} {$j < $m} {incr j} {
				set key "{$i},{$j}"
				set arr($key) 0
			}
		}
		return [array get arr]
	}

	proc max {a b} {
		if {$a > $b} {
			return $a
		} else {
			return $b
		}
	}

	proc lcs {str1 str2} {
		set len1 [string length $str1]
		set len2 [string length $str2]
		array set dp [zeros_array [expr {$len1 + 1}] [expr {$len2 + 1}]]
		for {set i 1} {$i <= $len1} {incr i} {
			for {set j 1} {$j <= $len2} {incr j} {
				set key "{$i},{$j}"
				if {[string index $str1 [expr {$i - 1}]] == [string index $str2 [expr {$j - 1}]]} {
					set key_val "{[expr {$i - 1}]},{[expr {$j - 1}]}"
					set val $dp($key_val)
					incr val
					set dp($key) $val
				} else {
					set key_val1 "{[expr {$i - 1}]},{$j}"
					set key_val2 "{$i},{[expr {$j - 1}]}"
					set val1 $dp($key_val1)
					set val2 $dp($key_val2)
					set dp($key) [max $val1 $val2]
				}
			}
		}
		set key "{$len1},{$len2}"
		return $dp($key)
	}
}