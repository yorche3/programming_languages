#include <iostream>
#include <math.h>
using namespace std;

#define _USE_MATH_DEFINES

/*
 * @author   Jorge Eduardo Ascencio Espíndola
 * @version  v1.0
 */

/**
 * Clase para conocer las coordenadas del centro de un circulo
 */
class Punto {
private:
  // coordenadas del plano XY
  int x, y;
public:
  /*
   * Constructor sin parametros
   */
  Punto(){}

  /*
   * Constructor de inicialización
   *
   * @param x_e  valor de entrada del eje X
   * @param y_e  valor de entrada del eje Y
   */
  Punto(int x_e, int y_e){
    x = x_e;
    y = y_e;
  }
  /*
   * @return  el valor de x
   */
  int get_x(){return x;}
  /*
   * @return  el valor de y
   */
  int get_y(){return y;}
};

/*
 * Clase que representa a un circulo con centro el el plano XY
 */
class Circulo{
private:
  double radio;
  Punto centro;
public:
  /*
   * Constructor de inicialización
   * @param p  un punto en el plano XY
   * @param r  distancia desde el centro
   */
  Circulo(Punto p, double r){
    centro = p;
    radio = r;
  }
  /* @return  el Punto que esta en en centro del circulo */
  Punto get_centro(){return centro;}
  /* @return  el tamaño del radio desde el centro */
  double get_radio(){return radio;}
  /* @return el area del circulo */
  double area(){return M_PI*radio*radio;}
};

int main(){
  int x;
  cout << "Valor de x : ";
  cin >> x;
  while(!cin){
    cout << "!Debe ser un entero! Valor de x : ";
    cin.clear();
    cin.ignore();
    cin >> x;
  }
  
  int y;
  cout << "Valor de y : ";
  cin >> y;
  while(!cin){
    cout << "!Debe ser un entero! Valor de y : ";
    cin.clear();
    cin.ignore();
    cin >> y;
  }
  
  double r;
  cout << "Valor del radio : ";
  cin >> r;
  while(!cin){
    cout << "!Debe ser un numero de punto flotante! Valor del radio: ";
    cin.clear();
    cin.ignore();
    cin >> r;
  }
  
  Punto p(x,y);
  Circulo c(p, r);
  cout << "El area del circulo es " << c.area() << endl;
}
