package main

import (
  "fmt"
  "math"
  "strconv"
  )
/*
*
* @author  Jorge Eduardo Ascencio Espíndola
* @version v1.0
*/

/*
* Declaración de la estrcutura Punto
*/
type Punto struct {
  x int // valor del eje X
  y int // valor del eje Y
}

/*
* Declaración de la estructura Circulo con centro en el plano XY
*/
type Circulo struct {
  centro Punto
  r float64
}

/*
* Cálcula el área del circulo c
*
* @param c : Circulo   circulo a calcular
*
* @return área del circulo
*/
func area(c Circulo) float64 {
  return math.Pi * c.r * c.r
}

func main(){
  var x_e string
  getX:
    for {
      fmt.Print("valor de x   ")
      fmt.Scanf("%s", &x_e)
      if isInt(x_e){
        break getX
      }
    }
  var y_e string
  getY:
    for {
      fmt.Print("valor de y   ")
      fmt.Scanf("%s", &y_e)
      if isInt(y_e){
	break getY
      }
    }
  x,_ := strconv.Atoi(x_e)
  y,_ := strconv.Atoi(y_e)
  p := Punto{x, y}
  var r_e string
  getR:
    for {
      fmt.Println("Valor del radio   ")
      fmt.Scanf("%s", &r_e)
      if isFloat(r_e){
        break getR
      }
    }
  r,_ := strconv.ParseFloat(r_e, 64)
  c := Circulo{p, r}
  fmt.Println(area(c))
}

/*
* Verifica si la cadena s es un entero
*/
func isInt(s string) bool {
  _, err := strconv.Atoi(s)
  return err == nil
}

/*
* Verifica si la cadena s es un flotante
*/
func isFloat(s string) bool {
  _, err := strconv.ParseFloat(s,64)
  return err == nil
}