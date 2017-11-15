#include <stdio.h>

int main(){
  char name[30];

  printf("¿Cuál es tu nombre?   ");
  scanf("%s", name);

  printf("Hola   %s\n", name);

  return 1;
}
