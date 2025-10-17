class Numerical {
  Numerical() {}

  static int fibonacci(int n) {
    if (n <= 0) {
      return -1
    } else if (n <= 2) {
      return n
    }
    def acc1 = 1
    def acc2 = 0
    def aux = 0
    while (n > 2) {
      aux = acc1 + acc2
      acc2 = acc1
      acc1 = aux
      n--
    }
    return acc1 + acc2
  }

  static int factorial(int n) {
    if (n <= 0) {
      return -1
    }
    def acc = 1
    while (n > 0) {
      acc *= n
      n--
    }
    return acc
  }

  static int gcd(int a, int b) {
    def aux = 0
    while (b > 0) {
      aux = a % b
      a = b
      b = aux
    }
    return a
  }

  static int lcm(int a, int b) {
    return (a / gcd(a, b)) * b
  }
}