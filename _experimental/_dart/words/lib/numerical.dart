int fibonacci(int n) {
  if(n < 0) {
    return -1;
  } else if(n < 2) {
    return n;
  }
  int acc1 = 1;
  int acc2 = 0;
  while(n > 2) {
    [acc2, acc1] = [acc1, acc1 + acc2];
    n--;
  }
  return acc1 + acc2;
}

int factorial(int n) {
  if(n < 0) {
    return -1;
  }
  int acc = 1;
  while(n > 1) {
    acc *= n--;
  }
  return acc;
}

int gcd(int a, int b) {
  while(b != 0) {
    [a, b] = [b, a % b];
  }
  return a;
}

int lcm(int a, int b) {
  return (a ~/ gcd(a, b)) * b;
}