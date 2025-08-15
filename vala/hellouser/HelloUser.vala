public class HelloUser : Object {
	static int main(string[] args) {
		
		stdout.printf ("Enter your name: ");
		string? name = stdin.read_line ();
		
		stdout.printf ("Hello, %s!\n", name);
		return 0;
    }
}
