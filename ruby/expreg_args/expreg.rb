# coding: utf-8

<<DOC
 * Verifica si la cadena word cumple la expresión regular
 *
 * @param word   cadena a evaluar     
 *
 * @return true si cumple, false en otro caso
DOC
def match(word)
  return word.match?(/^[A-Z]([a-z]|ñ){1,5}$/)
end

if ARGV.length != 1
  puts "Recibe un solo argumento\nDebe ser de la forma [A-Z]([a-z]|ñ){1,5}"
else
  if match(ARGV[0])
    puts "Felicidades la cadena es valida!"
  else
    puts "La cadena no es correcta"
  end
end
puts "Cerrando programa ..."
