import std.stdio;
import std.string;

void main() {
  write("¿Cuál es tu nombre?   ");

  char[] name;
  readln(name);
  name = strip(name);

  writeln("Hola   ", name);
}