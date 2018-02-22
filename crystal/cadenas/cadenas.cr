def hola
  return "Hola"
end

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

puts hola()
puts "Escribe una palabra"
word = read_line
puts "Es palindromo : #{palindromo(word)}"