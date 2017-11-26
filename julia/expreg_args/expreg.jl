#!/usr/bin/julia

#=
 * Verifica que la cadena word cumpla con la expresión regular
 *
 * @param word  cadena a validar
 *
 * @return  true si es vallida, false en otro caso
=#
function match(word)
  return ismatch(r"^[A-Z]([a-z]|ñ){1,5}$", word) # verifica que la cadena sea valida
end

if endof(ARGS) != 1
  println("Recibe un solo argumento\nDebe ser de la forma :")
else
  if match(ARGS[1])
    println("Felicidades la cadena es valida!")
  else
    println("La cadena no es correcta")
  end
end
println("Cerrando programa ...")
