#!/usr/bin/julia

# regresa una cadena con el saludo
function hola()
  return "Hola"
end

#=
  *param ch
  *param word
  
  regresa el número de repetiviones de ch en la cadena word  
=#
function repeticiones(ch, word)
  c = 0
  for w in word
    if ch == w
      c += 1
    end
  end
  return c
end

#=
  *param word
  verifica si la cadena word es palindromo
  regresa true si lo es
  regresa false en otro caso
=#
function palindromo(word)
  i = 1
  l = endof(word)
  while i < l
    if word[i] != word[l]
      return false
    end
    i += 1
    l -= 1
  end
  return true
end

#=
 *param word
 invierte una palabra
 regresa una cadena con la palabra invertida
=#
function invertir(word)
  l = endof(word)
  invStr = ""
  while l > 0
    invStr = invStr*string(word[l])
    l -= 1
  end
  return invStr
end


print(hola(),"\n")
print("Escribe una palabra   ")
word = readline(STDIN)
print("es palindromo : ", palindromo(word), "\n")
print("Caracter a buscar  ")
ch = readline(STDIN)[1]
print("repeticiones de $ch : ", repeticiones(ch, word), "\n")
print("cadena invertida  ", invertir(word), "\n")