#include <iostream>
using namespace std;

// método que regresa un cadena con un saludo
string hola(){
  string hello = "Hola";
  return hello;
}

// método que verifica si la cadena word es palindromo
// regresa true si es palindromo
// regresa false en otro caso
bool palindromo(const string& word){
  int f=0, l=word.length()-1;
  while(f<l){
    if(word[f++] != word[l--]) return false;
  }
  return true;
}

// método que regresa el número de repeticiones de un caracter en la cadena str
// regresa un entero con el número de repeticiones
int repeticiones(const char ch, const string& str){
  int c = 0;
  for(int i=0; i < str.length(); i++){
    if(str[i] == ch) c++;
  }
  return c;
}

int main(){
  string hello = hola();
  cout << hello << "\n";
  
  string word;
  cout << "Escribe una palabra    ";
  cin >> word;
  cout << "¿Es palindromo?    " << palindromo(word) << "\n";

  char ch;
  cout << "Caracter a buscar   ";
  cin >> ch;
  cout << "repeticiones de " << ch << " : " << repeticiones(ch, word) << "\n";
  
  return 1;
}
