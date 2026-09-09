use words::numerical::*;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fibonacci() {
        assert_eq!(fibonacci(-3), -1);
        assert_eq!(fibonacci(10), 55);
        assert_eq!(fibonacci(15), 610);
    }

    #[test]
    fn test_factorial() {
        assert_eq!(factorial(-3), -1);
        assert_eq!(factorial(5), 120);
        assert_eq!(factorial(10), 3628800);
    }

    #[test]
    fn test_gcd() {
        assert_eq!(gcd(48, 18), 6);
        assert_eq!(gcd(100, 25), 25);
        assert_eq!(gcd(17, 13), 1);
    }

    #[test]
    fn test_lcm() {
        assert_eq!(lcm(6, 4), 12);
        assert_eq!(lcm(21, 6), 42);
        assert_eq!(lcm(7, 3), 21);
    }
}