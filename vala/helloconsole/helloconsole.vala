class HelloWorld : GLib.Object {
    public static int main(string[] args) {
    	stdout.printf ("¿Cuál es tu nombre?   ");

	string? name = stdin.read_line ();
	if (name != null) {
	   stdout.printf ("Hola %s\n", name);
	}

        return 0;
    }
}
