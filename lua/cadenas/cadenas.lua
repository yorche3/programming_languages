--- Funciones sobre cadenas
-- @author  Jorge Eduardo Ascencio Espíndola
-- @versión v1.0

---
-- @return  un saludo
function hola()
  return "Hola"
end

--- función Palindromo
-- Verifica si una palabra es palindromo
-- @param word  palabra a evaluar
-- @return  true si lo es, false en otro caso
function palindromo(word)
  i, l = 1, string.len(word)
  while i < l do
    if word:sub(i,i) ~= word:sub(l,l) then
      return false
    end
    i = i + 1
    l = l - 1
    end
  return true
end

--- función Repeticiones
-- Cuenta el número de repeticiones de un carácter en una palabra
-- @param word  palabra a iterar
-- @param ch  carácter a buscar
-- @return  el número de apariciones
function repeticiones(word, ch)
  c = 0
  i, l = 1, string.len(word) + 1
  while i < l do
    if word:sub(i,i) == ch then
      c = c + 1
    end
    i = i + 1
  end
  return c
end

print(hola())
io.write("Escribe una palabra   ")
word = io.read()
print("Es palindromo :", palindromo(word))
io.write("caracter a buscar   ")
car = io.read()
ch = car:sub(1,1)
print("repeticiones :", repeticiones(word, ch))