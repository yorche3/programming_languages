import ballerina/io;

public function main() {
    string name = "";
    io:println("Enter your name:");
    name = io:readln();
    io:println("Hello, " + name + "!");
}