namespace eval numbers_recursive {
    namespace export fibonacci factorial sum_numbers
    # Fibonacci
    proc fibonacci {N} {
        if { $N <= 1 } {
            return $N
        } else {
            return [expr {[fibonacci [expr {$N - 1}]]} + [fibonacci [expr {$N - 2}]]]
        }
    }

    # Factorial
    proc factorial {N} {
        if { $N <= 1 } {
            return 1
        } else {
            return [expr {$N * [factorial [expr {$N - 1}]]}]
        }
    }

    # Sum of first N numbers
    proc sum_numbers {N} {
        if { $N <= 0 } {
            return 0
        } else {
            return [expr {$N + [sum_numbers [expr {$N - 1}]]}]
        }
    }
}