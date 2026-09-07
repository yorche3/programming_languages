class NumbersIterative {
    fun fibonacci(n: Int): Int {
        return fibonacciIter(n, 0, 1)
    }

    private fun fibonacciIter(n: Int, acc2: Int, acc1: Int): Int {
        if(n <= 0) return acc2
        else if(n <= 2) return acc1 + acc2
        else return fibonacciIter(n - 1, acc1, acc1 + acc2)
    }

    fun factorial(n: Int): Int {
        return factorialIter(n, 1)
    }

    private fun factorialIter(n: Int, acc: Int): Int {
        if(n <= 1) return acc
        return factorialIter(n - 1, n * acc)
    }

    fun sumNumbers(n: Int): Int {
        return sumNumbersIter(n, 0)
    }

    private fun sumNumbersIter(n: Int, acc: Int): Int {
        if(n <= 0) return acc
        return sumNumbersIter(n - 1, n + acc)
    }
}