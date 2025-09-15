use numbers::numbers_iterative::*;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fibonacci_iterative() {
        assert_eq!(fibonacci(0), 0);
        assert_eq!(fibonacci(1), 1);
        assert_eq!(fibonacci(5), 5);
        assert_eq!(fibonacci(10), 55);
    }

    #[test]
    fn test_factorial_iterative() {
        assert_eq!(factorial(0), 1);
        assert_eq!(factorial(1), 1);
        assert_eq!(factorial(5), 120);
        assert_eq!(factorial(10), 3628800);
    }

    #[test]
    fn test_sum_numbers_iterative() {
        assert_eq!(sum_numbers(0), 0);
        assert_eq!(sum_numbers(1), 1);
        assert_eq!(sum_numbers(5), 15);
        assert_eq!(sum_numbers(10), 55);
    }
}