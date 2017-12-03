#include <stdio.h>
#include <stdlib.h>
#include <regex.h>
#include <string.h>
#include <math.h>

// Funciones auxiliares *
int verify_int(char *number);
int verify_double(char *number);
char* limpia(char str[]);
// * fin

/**
 * Creación de la estructura Punto
 */
typedef struct{
  int x;
  int y;
} Punto;

/**
 * Creación de la estructura Circulo
 */
typedef struct {
  double radio;
  Punto centro;
} Circulo;

double area(Circulo c){
  return M_PI*c.radio*c.radio;
}

/*
 * código a usar en test
int main(int argc, char *argv[]){
  printf("%d\n", verify_int(argv[1]));
  printf("%d\n", verify_double(argv[2]));
  return 0;
}
*/
int main(){
  char e_x[255];
  int v = 1;
  while(v == 1){ // hasta que de un valor correcto
    printf("Valor de x : ");
    fgets(e_x, 255, stdin);
    limpia(e_x);
    v = verify_int(e_x);
    printf("%d\n", v);
  }
  v = 1;
  char e_y[255];
  while(v == 1){
    printf("Valor de y : ");
    fgets(e_y, 255, stdin);
    limpia(e_y);
    v = verify_int(e_y);
    printf("%d\n", v);
  }
  Punto p;
  p.x = atoi(e_x);
  p.y = atoi(e_y);
  printf("x : %d, y : %d\n", p.x, p.y);
  Circulo c;
  c.centro = p;
  v = 1;
  char e_r[255];
  while(v == 1){
    printf("Valor del radio : ");
    fgets(e_r, 255, stdin);
    limpia(e_r);
    v = verify_double(e_r);
    printf("%d\n", v);
  }
  c.radio = atof(e_r);
  printf("Area = %.2f\n", area(c));
  return 0;
}

/**
 * Verifica que la entrada sea un número entero
 *
 * @param number  entrada a evaluar
 * @return 1 si la entrada es valida, 0 en otro caso
 */
int verify_int(char *number){
  int rc;
  regex_t regex; // expresión regular
  rc = regcomp(&regex, "^(-)?[0-9]*[^.]", REG_EXTENDED); // Compila la expresión regular
  return regexec(&regex, number, 0, NULL, 0); // Evalua la cadena
}

/**
 * Verifica que la entrada sea un número de punto flotante
 *
 * @param number   entrada a evaluar
 * @return  0 si la entrada es valida, 1 en otro caso
 */
int verify_double(char *number){
  int rc;
  regex_t regex; // expresión regular
  rc = regcomp(&regex, "^(-)?[0-9]*.[0-9]*[^.]", REG_EXTENDED); // Compila la expresión regular
  return regexec(&regex, number, 0, NULL, 0); // Evalua la cadena
}

/*
 * Limpia la cadena quitando el salto de linea
 */
char* limpia(char str[]){
  str[strlen(str)-1] = '\0';
  return str;
}
