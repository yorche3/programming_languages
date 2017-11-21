#include <iostream>
using namespace std;

/*
 * @author   Jorge Eduardo Ascencio Espíndola
 * @version  v1.0
 */

/*
 * @return una cadena con un saludo
 */
string hola(){
  string hello = "Hola";
  return hello;
}

/* 
 * @param word : string
 * 
 * Verifica si la cadena word es palindromo
 * 
 * @return true (1) si  lo es, false (0) en otro caso
*/
bool palindromo(const string& word){
  int f=0, l=word.length()-1; // tamaño de cadena
  while(f<l){
    if(word[f++] != word[l--]) return false; // acceso a cadenas en un indice
  }
  return true;
}

/*
 * @param ch : char
 * @param str : string
 *
 * Cuenta el número de repeticiones del caracter ch en la cadena str
 *
 * @return el número de repeticiones
*/
int repeticiones(const char ch, const string& str){
  int c = 0;
  for(int i=0; i < str.length(); i++){
    if(str[i] == ch) c++; // comparar caracteres
  }
  return c;
}

/*
 * @param word : string
 * 
 * Invierte la cadena word
 *
 * @return la cadena invertida
*/
string invertir(const string& word){
  int l = word.length();
  char inv_str[l]; // crear cadena como arreglo de caracteres
  int f = l-1;
  for(int i=0; i<l;i++){
    inv_str[i] = word[f--]; // 'concatenar' cadenas
  }
  return inv_str;
}
  
int main(){
  string hello = hola();
  cout << hello << "\n";
  
  string word;
  cout << "Escribe una palabra    "; // imprimir en consola
  cin >> word; // obtener entrada desde consola
  cout << "¿Es palindromo?    " << palindromo(word) << "\n";

  char ch;
  cout << "Caracter a buscar   ";
  cin >> ch;
  cout << "repeticiones de " << ch << " : " << repeticiones(ch, word) << "\n";

  string inv_str = invertir(word);
  cout << "cadena invertida   " << inv_str << "\n"; // concatenar cadenas para imprimir
  return 1;
}
