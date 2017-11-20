#include <iostream>
using namespace std;

/* método que regresa un cadena con un saludo */
string hola(){
  string hello = "Hola";
  return hello;
}

/* 
 * param word : string
 * verifica si la cadena word es palindromo
 * regresa true (1) si es palindromo
 * regresa false (0) en otro caso 
*/
bool palindromo(const string& word){
  int f=0, l=word.length()-1;
  while(f<l){
    if(word[f++] != word[l--]) return false;
  }
  return true;
}

/*
 * param ch : char
 * param str : string
 * regresa el número de repeticiones del caracter ch en la cadena str
*/
int repeticiones(const char ch, const string& str){
  int c = 0;
  for(int i=0; i < str.length(); i++){
    if(str[i] == ch) c++;
  }
  return c;
}

/*
 * param word : string
 * invierte la cadena word
 * regresa una cadena
*/
string invertir(const string& word){
  int l = word.length();
  char inv_str[l];
  int f = l-1;
  for(int i=0; i<l;i++){
    inv_str[i] = word[f--];
  }
  return inv_str;
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

  string inv_str = invertir(word);
  cout << "cadena invertida   " << inv_str << "\n";
  return 1;
}
