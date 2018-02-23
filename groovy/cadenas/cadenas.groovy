/** Método que regresa un saludo */
String hola(){
  "Hola"
}

/**
* Verifica si una palabra es palindromo
*
* @param word  palabra a evaluar
* @return true si lo es, false en otro caso
*/
boolean palindromo(word){
  def l = word.length() - 1
  def i = 0
  def isp = true
  while(i < l){
    if(word[i++] != word[l--]){
    isp = false
    }
  }
  isp
}

/**
* Cuenta el número de repeticiones de un carácter en una palabra
*
* @param word  palabra a iterar
* @param ch  carácter a buscar
* @return el número de apariciones
*/
int repeticiones(word, ch){
  def c = 0
  for(w in word){
    if(w == ch){
      c++
    }
  }
  return c
}

/** Invierte una palabra */
String reversa(word){
  word.reverse()
}

println hola()
print "Escribe una palabra   "
def word = System.console().readLine()
println "Es palindromo : "+ palindromo(word)
print "carácter a buscar   "
def car = System.console().readLine()
ch = car[0]
println "repeticiones : "+ repeticiones(word, ch)
println "palabra invertida  "+ reversa(word)