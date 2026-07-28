package;

class NumbersRecursive {
    public function new() {}

    public function fibonacci(n:Int):Int {
        if (n <= 0) return 0;
        if (n == 1) return 1;
        return fibonacci(n - 1) + fibonacci(n - 2);
    }

    public function factorial(n:Int):Int {
        if (n <= 1) return 1;
        return n * factorial(n - 1);
    }

    public function sumNumbers(n:Int):Int {
        if (n <= 0) return 0;
        return n + sumNumbers(n - 1);
    }
}