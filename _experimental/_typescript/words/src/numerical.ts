export function fibonacci(n: number): number {
	if(n < 0) {
		return -1;
	} else if(n <= 1) {
		return n;
	}
	let acc1 = 1;
	let acc2 = 0;
	let aux = 0;
	while(n > 2) {
		aux = acc1 + acc2;
		acc2 = acc1;
		acc1 = aux;
		n--;
	}
	return acc1 + acc2;
}

export function factorial(n: number): number {
	if(n < 0) {
		return -1;
	}
	let acc = 1;
	while(n > 1) {
		acc *= n;
		n--;
	}
	return acc;
}

export function gcd(a: number, b: number): number {
	let aux = 0;
	while(b > 0) {
		aux = a % b;
		a = b;
		b = aux;
	}
	return a;
}

export function lcm(a: number, b: number): number {
	return (a * b) / gcd(a, b);
}