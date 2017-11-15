#include <iostream>
using namespace std;

int main(){
  string name;
  cout << "¿Cuál es tu nombre?   ";
  //  cin >> name;
  getline (cin, name);
  cout << "Hola  " << name << ".\n";
  return 0;
}
