#include <stdio.h>
#include <string.h>

/* 
 * función auxiliar para las cadenas que terminan con salto de linea
 * cambia \n (salto de linea) por \0 (carater de fin)
*/
char* limpia(char str[]);

/* regresa la cadena de saludo */
char* saludo(){
  return "Hola mundo!";
}

/* 
 * param str : char*
 * param inv_str : char*
 * hace una copia de la cadena str invertida en inv_str
*/
int invertir(char *str, char *inv_str){
  int i, l = strlen(str), j;
  j = l-1;
  for(i=0; i < l; i++){
    inv_str[j--] = str[i];
  }
  inv_str[l] = '\0';
  return 1;
}

/*
 * param word : char*
 * verifica si la cadena word es palindromo
 * regresa 1 si lo es
 * regresa 0 en otro caso
 * regresa -1 si hay un error 
*/
int palindromo(char *word){
  int i, l = strlen(word)-1;
  for(i=0; i < l; i++){
    if(word[i] != word[l--]){
      return 0;
    }
  }
  if(i == l) return 1;
  return -1;
}

/*
 * param ch : char
 * param str : char*
 * regresa el número de repeticiones del caracter ch en la cadena str 
*/
int repeticiones(char ch, char *str){
  int c = 0, i; // número de repeticiones al momento;
  for(i=0; i < strlen(str); i++){
    if(str[i] == ch) c++;
  }
  return c;
}

// funcion donde se muestra lo que realizan las funciones
// regresa 0 si se ejecuto correctamente
int main(){
  char* hello = saludo();
  printf("%s\n", hello);
  
  char user_str[255];
  fgets(user_str, 255, stdin);
  limpia(user_str);
  char inv_str[strlen(user_str)];
  invertir(user_str, inv_str);
  printf("%s\n%s\n", user_str, inv_str);

  printf("¿es palindromo? %i\n", palindromo(user_str));
  printf("Caracter a buscar?   ");
  char ch;
  scanf("%c", &ch);
  printf("repeticiones de '%c' en -%s- : %i\n", ch, user_str, repeticiones(ch, user_str));
  
  return 1;
}

char* limpia(char str[]){
  str[strlen(str)-1] = '\0';
  return str;
}
