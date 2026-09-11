public struct NumbersRecursive {
    public static func fibonacci(_ n: Int) -> Int {
        if n <= 1 { return n }
        return fibonacci(n - 1) + fibonacci(n - 2)
    }
    
    public static func factorial(_ n: Int) -> Int {
        if n <= 1 { return 1 }
        return n * factorial(n - 1)
    }
    
    public static func sumNumbers(_ n: Int) -> Int {
        if n == 0 { return 0 }
        return n + sumNumbers(n - 1)
    }
}