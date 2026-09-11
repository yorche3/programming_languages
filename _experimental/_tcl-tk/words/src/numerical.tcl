namespace eval numerical {
  namespace export fibonacci factorial gcd lcm

	proc fibonacci {n} {
		if { $n < 0 } {
			return -1
		} elseif { $n <= 1 } {
			return $n
		}
		set acc1 1
		set acc2 0
		set i 2
		while {$i < $n} {
			set aux [expr {$acc1 + $acc2}]
			set acc2 $acc1
			set acc1 $aux
			set i [expr {$i + 1}]
		}
		return [expr {$acc1 + $acc2}]
	}

	proc factorial {n} {
		if { $n < 0 } {
			return -1
		}
		set acc 1
		set i 1
		while {$i <= $n} {
			set acc [expr {$i * $acc}]
			set i [expr {$i + 1}]
		}
		return $acc
	}

	proc gcd {a b} {
		if { $b == 0 } {
			return $a
		} else {
			return [gcd $b [expr {$a % $b}]]
		}
	}

	proc lcm {a b} {
		return [expr {[expr {$a / [gcd $a $b]}] * $b}]
	}
}