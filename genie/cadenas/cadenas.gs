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
def repeticiones(word:string, ch:char)
  var l = word.length;
  count:int  = 0;
  for var i = 0 to l
    if word[i] == ch
      count++;
  print "%d", count;

init
  print hola();
  repeticiones("hello", 'e');