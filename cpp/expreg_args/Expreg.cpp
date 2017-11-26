/*
 * @author    Jorge Eduardo Ascencio Espíndola
 * @version   v0.1
 */

#include <iostream>
#include <regex>
using namespace std;

/*
* Compara la cadena str con la expresión regular regex = [A-Z]([a-z]|ñ){1,5
*
* @param str   cadena a evaluar
*
* @return 0 si regexec valida la cadena, 1 en otro caso
*/
bool match(string str){
  int rc;
  string expreg = "[A-Z]([a-z]|ñ){1,5}"; // Expresión regular esperada
  regex ex(expreg); // Compila la expresión regular
  
  return regex_match(str, ex); // Evalua la cadena
}

int main(int argc, char* argv[]){
  cout << "argc = " << argc << "\n";
  if(argc  != 2){
    cout << "El programa solo recibe una entrada\nDebe ser de la forma : [A-Z]([a-z]|ñ){1,5}\n";
    cout << "Cerrando programa ...\nCódigo de salida : -1\n";
    return -1;
  }
  if(match(argv[1])){
    cout << "Felicidades la cadena es correcta!\n";
    cout << "Cerrando programa ...\n";
  } else {
    cout << "La cadena no es valida\n";
    cout << "Cerrando programa ...\nCódigo de salida : 1\n";
    return 1;
  }
  cout << "Código de salida : 0\n";
  return 0;
}
