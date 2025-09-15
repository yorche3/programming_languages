package;

class NumbersIterative {
    public function new() {}

    public function fibonacci(n:Int):Int {
        return fibonacci_iter(n, 0, 1);
    }

    private function fibonacci_iter(n:Int, acc2:Int, acc1:Int):Int {
        if (n <= 0) return acc2;
        if (n <= 2) return acc1 + acc2;
        return fibonacci_iter(n - 1, acc1, acc1 + acc2);
    }

    public function factorial(n:Int):Int {
        return factorial_iter(n, 1);
    }

    private function factorial_iter(n:Int, acc:Int):Int {
        if (n <= 1) return acc;
        return factorial_iter(n - 1, n * acc);
    }

    public function sumNumbers(n:Int):Int {
        return sum_numbers_iter(n, 0);
    }

    private function sum_numbers_iter(n:Int, acc:Int):Int {
        if (n <= 0) return acc;
        return sum_numbers_iter(n - 1, n + acc);
    }
}