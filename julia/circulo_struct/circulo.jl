#!/usr/bin/julia

#=
 * Definición de la estructura Punto
=#
struct Punto
  x::Int32
  y::Int32
end

#=
 * Definición de la estructura Circulo
=#
struct Circulo
  centro::Punto
  radio::Float64
end

function area(c::Circulo)
  return pi * c.radio * c.radio
end

# Verifica que la entrada sea un entero
function isInt(str)
  return ismatch(r"^(-)?[0-9]+$", str) # verifica que la cadena sea valida
end

# Verifica que la entrada sea un flotante
function isFloat(str)
  return ismatch(r"^(-)?[0-9]+(.[0-9]*)?$", str) # verifica que la cadena sea valida
end

x = 0
while true
  print("valor de x:   ")
  x_e = readline(STDIN)
  if isInt(x_e)
    x = parse(Int, x_e)
    break
  end
end
y = 0
while true
  print("valor de y:   ")
  y_e = readline(STDIN)
  if isInt(y_e)
    y = parse(Int, y_e)
    break
  end
end
r = 0
while true
  print("valor del radio:   ")
  r_e = readline(STDIN)
  if isFloat(r_e)
    r = parse(Float64, r_e)
    break
  end
end
println(area(Circulo(Punto(x,y), r)))