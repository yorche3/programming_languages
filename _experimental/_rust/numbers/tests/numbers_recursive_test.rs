use numbers::numbers_recursive::*;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fibonacci_recursive() {
        assert_eq!(fibonacci(0), 0);
        assert_eq!(fibonacci(1), 1);
        assert_eq!(fibonacci(5), 5);
        assert_eq!(fibonacci(10), 55);
    }

    #[test]
    fn test_factorial_recursive() {
        assert_eq!(factorial(0), 1);
        assert_eq!(factorial(1), 1);
        assert_eq!(factorial(5), 120);
    }

    #[test]
    fn test_sum_numbers_recursive() {
        assert_eq!(sum_numbers(0), 0);
        assert_eq!(sum_numbers(1), 1);
        assert_eq!(sum_numbers(5), 15);
        assert_eq!(sum_numbers(10), 55);
    }
}