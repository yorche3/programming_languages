# Returns un saludo
def hola
  return "Hola"
end

# Verifica si una palabra es palindromo
#
# param *word*  palabra a evaluar
# returns  true si lo es false en otro caso
def palindromo(word)
  i = 0
  l = word.size - 1
  while(i < l)
    if word[i] != word[l]
      return false
    end
    i+=1
    l-=1
  end
  return true
end

# Cuenta el número de repeticiones de un carácter en una palabra
#
# param *word*  palabra a iterar
# param *ch*    carácter a buscar
# returns el número de apariciones
def repeticiones(word, ch)
  i = 0
  l = word.size
  c = 0
  while(i < l)
    if word[i] == ch
      c += 1
    end
    i += 1
  end
  return c
end

# Invierte una cadena
def reversa(word)
  return word.reverse
end

puts hola()
puts "Escribe una palabra"
word = read_line
puts "Es palindromo : #{palindromo(word)}"
puts "Carácter a buscar"
car = read_line
ch = car[0]
puts "repeticiones : #{repeticiones(word,ch)}"
puts "palabra invertida   #{reversa(word)}"