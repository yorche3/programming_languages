public function fibonacci(int n) returns int {
    if n < 0 {
        return -1;
    } else if n <= 1 {
        return n;
    }
    int acc2 = 0;
    int acc1 = 1;
    foreach var i in 2..<n {
        [acc2, acc1] = [acc1, acc1 + acc2];
    }
    return acc1 + acc2;
}

public function factorial(int n) returns int {
    if n < 0 {
        return -1;
    }
    int acc = 1;
    foreach var i in 2..<n+1 {
        acc = acc * i;
    }
    return acc;
}

public function gcd(int a, int b) returns int {
    int x = a;
    int y = b;
    while y != 0 {
        [x, y] = [y, x % y];
    }
    return x;
}

public function lcm(int a, int b) returns int {
    return (a / gcd(a, b)) * b;
}