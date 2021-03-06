#include <stdio.h>
#include <string.h>
#include <regex.h>

/*
 * @author   Jorge
 * @version  v0.1
 */

/*
 * Compara la cadena str con la expresión regular regex = [A-Z]([a-z]|ñ){1,5}
 *
 * @param str   cadena a evaluar
 *
 * @return 0 si regexec valida la cadena, 1 en otro caso
 */
int match(char *str){
  int rc;
  regex_t regex; // Expresión regular compilada
  rc = regcomp(&regex, "[A-Z]([a-z]|ñ){1,5}", REG_EXTENDED); // Compila la expresi+on regular
  return regexec(&regex, str, 0, NULL, 0); // Evalua la cadena
}


/*
 * Programa verificador de cadenas, recibe una cadena como argumento de consola y la valida,
 * la cadena debe cumplir con la expresión regular
 *
 * @param argc   - número de argumentos
 * @param argv   - arreglo de cadenas con los argumentos
 *
 * @return 0 si se ejecuto correctamente el programa, -1 si no hay entrada, 1 si no es valida la entrada
 */
int main( int argc, char *argv[] )  {
  if(argc != 2){
    printf("El programa recibe un solo argumento\nDebes pasar una cadena válida con el formato : [A-Z][a-z]{1,5}\n");
    printf("Cerrando el programa...\ncódigo de salida : -1\n");
    return -1;
  } else {
    if(match(argv[1])){
      printf("Argumento no valido\nCerrando el programa ...\ncódigo de salida : 1\n");
      return 1;
    }
    printf("Cadena valida, ¡Felicidades!\n");
  }
  printf("Cerrando el programa ...\ncódigo de salida : 0\n");
  return 0;
}
