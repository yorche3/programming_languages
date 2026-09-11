namespace eval numbers_iterative {
    namespace export fibonacci factorial sum_numbers
    # Fibonacci
    proc fibonacci {N} {
        return [fibonacci_iter $N 0 1]
    }

    proc fibonacci_iter {N Acc2 Acc1} {
        if { $N <= 1 } {
            return $Acc2
        } elseif { $N == 2 } {
            return [expr {$Acc1 + $Acc2}]
        } else {
            return [fibonacci_iter [expr {$N - 1}] $Acc1 [expr {$Acc1 + $Acc2}]]
        }
    }

    # Factorial
    proc factorial {N} {
        return [factorial_iter $N 1]
    }

    proc factorial_iter {N Acc} {
        if { $N <= 1 } {
            return $Acc
        } else {
            return [factorial_iter [expr {$N - 1}] [expr {$N * $Acc}]]
        }
    }

    # Sum of first N numbers
    proc sum_numbers {N} {
        return [sum_numbers_iter $N 0]
    }

    proc sum_numbers_iter {N Acc} {
        if { $N <= 0 } {
            return $Acc
        } else {
            return [sum_numbers_iter [expr {$N - 1}] [expr {$N + $Acc}]]
        }
    }
}