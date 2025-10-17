package;

class Numerical {
  public static function fibonacci(n: Int): Int {
    if (n < 0) {
      return -1;
    } else if (n < 2) {
      return n;
    }
    var acc2 = 0;
    var acc1 = 1;
    var aux = 0;
    while (n > 2) {
      aux = acc1 + acc2;
      acc2 = acc1;
      acc1 = aux;
      n--;
    }
    return acc1 + acc2;
  }

  public static function factorial(n: Int): Int {
    if (n < 0) {
      return -1;
    }
    var acc = 1;
    while (n > 1) {
      acc *= n--;
    }
    return acc;
  }

  public static function gcd(a: Int, b: Int): Int {
    var aux = 0;
    while (b != 0) {
      aux = a % b;
      a = b;
      b = aux;
    }
    return a;
  }

  public static function lcm(a: Int, b: Int): Int {
    return (Std.int(a / gcd(a, b))) * b;
  }
}