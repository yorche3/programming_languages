class HelloUser {
    static public function main() {
        trace("Enter your name: ");
        var name = Sys.stdin().readLine();
        trace("Hello, " + name);
    }
}