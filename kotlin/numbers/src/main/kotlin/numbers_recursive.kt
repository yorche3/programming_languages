class NumbersRecursive {
    fun fibonacci(n: Int): Int {
        return if (n <= 1) n else fibonacci(n - 1) + fibonacci(n - 2)
    }

    fun factorial(n: Int): Int {
        return if (n <= 1) 1 else n * factorial(n - 1)
    }

    fun sumNumbers(n: Int): Int {
        return if (n <= 1) n else n + sumNumbers(n - 1)
    }
}