int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/scaffold/suite-missing", () => {
        assert_not_reached ();
    });
    return Test.run ();
}
