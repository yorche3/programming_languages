package main

import "fmt"

/* función que regresa una cadena con un saludo */
func hola() string{
  return "Hola"
}

/*
  param word : string

  función que te dice si la cadena word es palindromo
  regresa true si es palindromo
  regresa false en otro caso
*/
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

/*
  param word : string

  función que invierte la cadena word
  regresa la cadena invertida
*/
func invertir(word string) string{
  i := 0
  l := len(word)
  f := l-1
  inv_str := ""
  for i < l {
    inv_str += string(word[f])
    i += 1
    f -= 1
  }
  return inv_str
}

func main() {
  fmt.Println(hola())
  
  fmt.Print("Escriba una palabra   ")
  var word string
  fmt.Scanf("%s", &word)
  fmt.Println("Es palindromo :  ", palindromo(word))
  inv_str := invertir(word)
  fmt.Println("cadena invertida  ", inv_str)
  
}