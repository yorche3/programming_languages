using @MODULE@;

public void main() {
    stdout.printf("
Testing shlib");
    stdout.printf("
	2 + 3 is %d", sum(2, 3));
    stdout.printf("
	8 squared is %d\n", square(8));
}
