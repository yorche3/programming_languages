package main

import(
   "os"
   "fmt"
   "regexp"
)

/*
* Verifica si la cadena str cumple con la expresión regular [A-Z]([a-z]|ñ){1,5}
*
* @param str : string   cadena a evaluar
*
* @return true si cumple, false en otro caso
*/
func match(str string) bool{
  var expreg = regexp.MustCompile("[A-Z]([a-z]|ñ){1,5}") // compila la expresión regular
  return expreg.MatchString(str)  // evalua la cadena con la expresión regular
}

func main(){
  if len(os.Args) != 2 {
    fmt.Println("Debe ser un solo argumento\nDebe ser de la forma [A-Z]([a-z]|ñ){1,5}")
  } else { 
    if match(os.Args[1]) {
      fmt.Println("Felicidades la cadena es valida!")
    } else {
      fmt.Println("Cadena no es correcta")
    }
  }
  fmt.Println("Cerrando programa ...")
}