package main

import "fmt"

/*
 Genera un saludo

 @return una cadena con un saludo
 */
func hola() string{
  return "Hola"
}

/*
 * @param word : string
 *
 * función que te dice si la cadena word es palindromo
 * 
 * @return true si lo es, false en otro caso
*/
func palindromo(word string) bool{
  f := 0
  l := len(word)-1 // tamaño de la cadena
  for f < l {
    if word[f] != word[l] { // acceder a posicion de cadena
      return false
    }
    f+=1
    l-=1
  }
  return true
}

/*
 * @param char : string
 * @param word : string
 *
 * Cuenta el número de ocurrencias del caracter ch en la cadena word
 *
 * @return número de ocurrencias
 */
func repeticiones(char string, word string) int{
  i := 0
  l := len(word)
  c := 0
  ch := char[0] // obtener un caracter
  for i < l {
    if ch == word[i] {
      c+=1;
    }
    i+=1
  }
  return c
}

/*
 * @param word : string
 *
 * Invierte la cadena word
 *
 * @return la cadena invertida
*/
func invertir(word string) string{
  i := 0
  l := len(word)
  f := l-1
  inv_str := ""
  for i < l {
    inv_str += string(word[f]) // concatenar cadena caracter
    i += 1 // 'autoincrementar'
    f -= 1
  }
  return inv_str
}

func main() {
  fmt.Println(hola())
  
  fmt.Print("Escriba una palabra   ") // imprimir sin salto de linea
  var word string
  fmt.Scanf("%s", &word) // obtener entrada desde consola
  fmt.Println("Es palindromo :  ", palindromo(word)) // concatenar cadena de impresión
  fmt.Print("Caracter a buscar   ")
  var ch string
  fmt.Scanf("%s", &ch)
  fmt.Println("repeticiones : ", repeticiones(ch, word))
  inv_str := invertir(word)
  fmt.Println("cadena invertida  ", inv_str)
}