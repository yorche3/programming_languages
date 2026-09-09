public struct NumbersIterative {
    public static func fibonacci(_ n: Int) -> Int {
        return fibonacciIter(n, 0, 1)
    }
    
    private static func fibonacciIter(_ n: Int, _ acc2: Int, _ acc1: Int) -> Int {
        if n <= 1 { return n }
        if n == 2 { return acc1 + acc2 }
        return fibonacciIter(n - 1, acc1, acc1 + acc2)
    }
    
    public static func factorial(_ n: Int) -> Int {
        return factorialIter(n, 1)
    }
    
    private static func factorialIter(_ n: Int, _ acc: Int) -> Int {
        if n <= 1 { return acc }
        return factorialIter(n - 1, n * acc)
    }
    
    public static func sumNumbers(_ n: Int) -> Int {
        return sumNumbersIter(n, 0)
    }
    
    private static func sumNumbersIter(_ n: Int, _ acc: Int) -> Int {
        if n == 0 { return acc }
        return sumNumbersIter(n - 1, n + acc)
    }
}