package main

import "fmt"

func main(){
  var name string
  fmt.Print("¿Cuál es tu nombre?   ")
  fmt.Scanf("%s", &name)
  fmt.Println("Hola   ", name)
}