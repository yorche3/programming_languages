package com.example.words;

public class Numerical {
	public static int fibonacci(int n)
	{
		if (n < 0)
		{
			return -1;
		}
		if (n <= 2)
		{
			return n;
		}
		int acc1 = 1;
		int acc2 = 0;
		int aux;
		for (int i = 3; i <= n; i++)
		{
			aux = acc1 + acc2;
			acc2 = acc1;
			acc1 = aux;
		}
		return acc1 + acc2;
	}

	public static int factorial(int n)
	{
		if (n < 0)
		{
			return -1;
		}
		if (n == 0 || n == 1)
		{
			return 1;
		}
		int acc = 1;
		for (int i = 2; i <= n; i++)
		{
			acc *= i;
		}
		return acc;
	}

	public static int gcd(int a, int b)
	{
		int aux;
		while (b != 0)
		{
			aux = a % b;
			a = b;
			b = aux;
		}
		return a;
	}

	public static int lcm(int a, int b)
	{
		return (a / gcd(a, b)) * b;
	}
}
