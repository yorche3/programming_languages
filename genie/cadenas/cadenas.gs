[indent=2]

/*
Función que regresa un saludo
*/
def hola():string
  return "Hola";

/*
Cuenta el número de repeticiones de un caracter en una cadena

@param word  palabra sobre la que se itera
@param ch  carácter a buscar

@return  el número de coincidencias
*/
def repeticiones(word:string, ch:char):int
  var l = word.length;
  count:int  = 0;
  for var i = 0 to l
    if word[i] == ch
      count++;
  return count;

/*
Verifica si una palabra es palindromo

@param word  palabra a evaluar
@param ch  carácter a buscar

@return  true si lo es, false en otro caso
*/
def palindromo(word:string):bool
  var l = word.length - 1;
  var i = 0;
  while i < l
    if word[i++] != word[l--]
      return false;
  return true;

/*
Invierte una palabra

@param word  palabra a invertir

@returns la palabra invertirda
*/
def reversa(word:string):string
  return word.reverse();

init
  print hola();
  print "Escribe una palabra"
  word:string = stdin.read_line();
  is_pal:string = palindromo(word).to_string();
  print "Es palindromo : %s", is_pal;
  print "Caracter a buscar"
  car:string = stdin.read_line();
  ch:char = car[0];
  print "repeticiones : %d", repeticiones(word, ch);
  print "palabra invertida %s", reversa(word);