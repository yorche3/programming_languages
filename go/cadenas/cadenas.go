package main

import "fmt"

// método que regresa una cadena con un saludo
func hola() string{
  return "Hola"
}

// método que te dice si la cadena word es palindromo
// regresa si es palindromo
// regresa en otro caso
func palindromo(word string) bool{
  f := 0
  l := len(word)-1
  for f < l {
    if word[f] != word[l] {
      return false
    }
    f+=1
    l-=1
  }
  return true
}

func main() {
  fmt.Println(hola())
  
  fmt.Print("Escriba una palabra   ")
  var word string
  fmt.Scanf("%s", &word)
  fmt.Println("Es palindromo :  ", palindromo(word))

  
}