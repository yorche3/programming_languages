#include <stdio.h>
#include <string.h>

/*
 * @author   Jorge Eduardo Ascencio Espíndola
 * @version  v1.0
 */


/* 
 * función auxiliar para las cadenas que terminan con salto de linea
 * cambia \n (salto de linea) por \0 (carater de fin)
*/
char* limpia(char str[]);

/* 
   Genera una cadena con un saludo
   @return cadena de saludo
*/
char* saludo(){
  return "Hola mundo!";
}

/* 
 * @param str : char*
 * @param inv_str : char*
 *
 * Hace una copia de la cadena str invertida en inv_str
 * 
 *@return 1 la funcion se realizo correctamente
*/
int invertir(char *str, char *inv_str){
  int i, l = strlen(str), j; // tamaño de la cadena -función de string.h-
  j = l-1;
  for(i=0; i < l; i++){
    inv_str[j--] = str[i]; // 'concatenar cadena'
  }
  inv_str[l] = '\0';
  return 1;
}

/*
 * @param word : char*
 * 
 * Verifica si la cadena word es palindromo
 * 
 * @return 1 si lo es, -1 si hay un error, 0 en otro caso
*/
int palindromo(char *word){
  int i, l = strlen(word)-1;
  for(i=0; i < l; i++){
    if(word[i] != word[l--]){ // comparar caracteres
      return 0;
    }
  }
  if(i == l) return 1;
  return -1;
}

/*
 * param ch : char
 * param str : char*
 * 
 * Cuenta el número de repeticiones del caracter ch en la cadena str
 *
 * @return un entero con el número de repeticiones
*/
int repeticiones(char ch, char *str){
  int c = 0, i; // concurrences = número de ocurrencias
  for(i=0; i < strlen(str); i++){
    if(str[i] == ch) c++; // incremento de ocurrencias -autoincremento-
  }
  return c;
}

// funcion donde se muestra lo que realizan las funciones
// regresa 0 si se ejecuto correctamente
int main(){
  char* hello = saludo();
  printf("%s\n", hello); // imprimir en consola
  
  char user_str[255];
  fgets(user_str, 255, stdin); // obtener linea de entrada desde consola
  limpia(user_str);
  char inv_str[strlen(user_str)]; // crear una cadena como arrreglo de caracteres
  invertir(user_str, inv_str);
  printf("%s\n%s\n", user_str, inv_str);

  printf("¿es palindromo? %i\n", palindromo(user_str));
  printf("Caracter a buscar?   ");
  char ch;
  scanf("%c", &ch); // obtener y verificar una entrada desde consola con el tipo especificado
  printf("repeticiones de '%c' en -%s- : %i\n", ch, user_str, repeticiones(ch, user_str));
  
  return 1;
}

char* limpia(char str[]){
  str[strlen(str)-1] = '\0';
  return str;
}
