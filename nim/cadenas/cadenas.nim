## Manejo de cadenas
##
## @author  Jorge Eduardo Ascencio Espíndola
## @version v1.0

## Regresa un saludo
proc hola(): string =
  return "Hola"

## Verifica si una cadena es palindromo
##
## @param word  palabra a evaluar
## @return  true si lo es, false en otro caso
proc palindromo(word: string): bool =
  var ln: int = word.len - 1
  var i: int = 0
  while i < ln:
    if word[i] != word[ln]:
      return false
    i += 1
    ln -= 1
  return true

## Cuenta el número de repeticiones de un carácter en una palabra
##
## @param word  palabra a iterar
## @param ch  carácter a buscar
## @return  el número de apariciones
proc repeticiones(word: string, ch: char): int =
  var c: int = 0
  for i in 0..<word.len:
    if word[i] == ch:
      c += 1
  return c

## Invierte una palabra
proc reversa(word: var string): string =
  var i: int = 0
  var ln: int = word.len - 1
  while i < ln:
    swap(word[i], word[ln])
    i += 1
    ln -= 1
  return word

echo hola()
echo "Escribe una palabra"
var word: string = readLine(stdin)
echo "Es palindromo : ", palindromo(word)
echo "carácter a buscar"
var car: string = readLine(stdin)
var ch: char = car[0]
echo "repeticiones : ", repeticiones(word, ch)
echo "palabra invertida  ", reversa(word)