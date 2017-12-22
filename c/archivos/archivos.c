//#include "archivos.h"
#include <stdio.h>
#include <string.h>

/*
 * @author   Jorge Eduardo Ascencio Espíndola
 * @version  v1.0
 */

/*
 * función que crea un archivo con contenido
 *
 * @param nombre   el nombre del archivo a crear
 * @return 0 si se creo correctamente, 1 si el archivo no se pudo abrir, -1 en otro caso
 */
int create_file(char *nombre){
  FILE *fp;

  strcat(nombre, ".txt");
  fp = fopen(nombre, "a+"); // creamos el archivo
  if(fp == NULL) return 1;
  fprintf(fp, "This is testing for fprintf...\n");
  fputs("This is testing for fputs...\n", fp);
  if(fclose(fp) == 0)return 0;
  return -1;
}

/*
 * copia el contenido de un archivo a su copia y agrega contenido
 *
 * @param nombre   nombre del archivo sin extension
 * @return 0 si se copio correctamente, 1 si hubo algún error
 */
int copy_file(char *nombre){
  FILE *fo; // archivo origen
  FILE *fd; // archivo destino

  fo = fopen(nombre, "r"); // el archivo origen solo se lee

  strcat(nombre, "_copia.txt"); // nombre del archivo destino 
  fd = fopen(nombre, "a+"); // el archivo destino se crea
  if(fd == NULL) return 1;
  
  char linea[255];

  fprintf(fd, "Archivo copia\n");
  
  while(fgets(linea, 255, fo)){
    fputs(linea, fd); // copiamos el contenido del archivo origen al archivo destino
  }

  fclose(fo);
  fclose(fd);
  return 0;
}

int main(int argc, char *argv[]){
  if(argc != 2){
    printf("Expected: ./archivos nombre_archivo\nCerrando programa ... Failed\n");
    return 1;
  }

  create_file(argv[1]);
  copy_file(argv[1]);
  printf("Cerrando programa ... OK\n");
  return 0;
}
