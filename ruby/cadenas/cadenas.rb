# coding: utf-8

<<-DOC
-regresa una cadena con un saludo
DOC
def hola()
  return 'Hola'
end

<<-DOC
 * @param ch caracter a buscar
 * @param word cadena a iterar
 *
 * Cuenta el número de repeticiones del caracter ch en la cadena word
 * 
 * @return el número de repeticiones
DOC
def repeticiones(ch, word)
  c = 0
  i = 0
  l = word.length
  while i < l
    if word[i] == ch # acceder a una posicion de la cadena
      c+=1 # 'autoincremento'
    end
    i+=1
  end
  return c
end

<<-DOC
 * @param word
 *
 * Verifica si una palabra es palindromo
 *
 * @return true si lo es, false en otro caso
DOC
def palindromo(word)
  i=0
  f=word.length-2;
  while i < f
    if word[i] != word[f]
      return false
    end
    i+=1
    f-=1
  end
  return true
end

<<-DOC
 * @param word palabra a invertir
 *
 * Invierte una palabra
 *
 * @return cadena con la palabra invertida
DOC
def invertir(word)
  inv_str = ''
  l=word.length-2 # tamaño de la cadena
  while l > -1 do
    inv_str << word[l] # concatena cadena caracter
    l-=1
  end
  return inv_str
end

puts hola() # imprime con salto de linea
print 'Escibe una palabra  ' # imprime sin salto de linea
word = gets # obtiene entrada desde consola
puts 'Es palindromo :  '+ String(palindromo(word)) # concatena string
print 'Caracter a buscar   '
ch = gets[0]
puts 'numero de repeticioines  : '+ String(repeticiones(ch, word)) # convierte a cadena
puts 'palabra invertida  '+ invertir(word)
