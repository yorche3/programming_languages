{-|
1;2802;0cModule      : Cadenas

Author      : Jorge Eduardo Ascencio Espíndola
Versión     : v1.0
-}

{-|
  Verifica si una palabra es palindromo.
  Recibe un argumento de tipo 'String'.
  Regresa True si lo es, False en otro caso.
-}
palindromo :: String -> Bool
palindromo word = word == reverse word

{-|
  Cuenta el número de repeticiones de un carácter en una palabra.
  Recibe un argumento de tipo 'String' sobre la que se iterará
  y un argumento de tipo 'Char'.
  
-}
repeticiones :: String -> Char -> Integer
repeticiones [] ch = 0
repeticiones xs ch = repe xs ch 0

repe :: String -> Char -> Integer -> Integer
repe [] ch c = c
repe (x:xs) ch c = if x == ch then repe (xs) ch c+1 else repe (xs) ch c

{-|
  Invierte una palabra.
  Recibe un argumento de tipo 'String'
-}
reversa :: String -> String
reversa word = reverse word

main = do
  print "Hola"
  putStrLn "Escribe una palabra   "
  word <- getLine
  putStr "Es palindromo : "
  print(palindromo(word))
  putStrLn "carácter a buscar   "
  ch <- getChar
  putStr "repeticiones : "
  print(repeticiones word ch)
  putStr "palabra invertida   "
  print(reversa(word))