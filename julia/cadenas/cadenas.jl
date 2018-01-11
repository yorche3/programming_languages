#!/usr/bin/julia

#=
 * @author   Jorge Eduardo Ascencio Espíndola
 * @version  v1.0
=#

# regresa una cadena con el saludo
function hola()
  return "Hola"
end

#=
 * @param ch
 * @param word
 *
 * Cuenta el número de repeticiones de ch en la cadena word
 *
 * @return el número de repeticiones  
=#
function repeticiones(ch, word)
  c = 0
  for w in word # cadena como arreglo
    if ch == w
      c += 1 # 'autoincrementar'
    end
  end
  return c
end

#=
 * @param word
 *
 * Verifica si la cadena word es palindromo
 *
 * @return true si lo es, false en otro caso
=#
function palindromo(word)
  i = 1
  l = endof(word) # tamaño de la cadena
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
 * @param word
 *
 * Invierte la palabra word
 *
 * @return una cadena con la palabra invertida
=#
function invertir(word)
  l = endof(word)
  invStr = ""
  while l > 0
    invStr = invStr*string(word[l]) # concatenar cadenas
    l -= 1
  end
  return invStr
end


print(hola(),"\n")
print("Escribe una palabra   ") # imprimir en consola
word = readline(STDIN) # entrada desde consola
print("es palindromo : ", palindromo(word), "\n")
print("Caracter a buscar  ")
ch = readline(STDIN)[1]
print("repeticiones de $ch : ", repeticiones(ch, word), "\n")
print("cadena invertida  ", invertir(word), "\n")