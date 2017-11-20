# coding: utf-8

<<-DOC
-regresa una cadena con un saludo
DOC
def hola()
  return 'Hola'
end

<<-DOC
*param ch caracter a buscar
*param word cadena a iterar

Cuenta el número de repeticiones del caracter ch en la cadena word

-regresa el número de repeticiones
DOC
def repeticiones(ch, word)
  c = 0
  i = 0
  l = word.length
  while i < l
    if word[i] == ch
      c+=1
    end
    i+=1
  end
  return c
end

<<-DOC
*param word

Verifica si una palabra es palindromo

-return true si lo es, false en otro caso
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
*param word palabra a invertir

invierte una palabra

-retrun cadena con la palabra invertida
DOC
def invertir(word)
  inv_str = ''
  l=word.length-2
  while l > -1 do
    inv_str << word[l]
    l-=1
  end
  return inv_str
end

puts hola()
print 'Escibe una palabra  '
word = gets
puts 'Es palindromo :  '+ String(palindromo(word))
print 'Caracter a buscar   '
ch = gets[0]
puts 'numero de repeticioines  : '+ String(repeticiones(ch, word))
puts 'palabra invertida  '+ invertir(word)
