/** Provides a service as described.
 *
 * @author  Jorge Eduardo Ascencio Espíndola
 * @version v.10
 */
object Cadenas {

  /** Regresa una cadena con un saludo. */
  def hola(): String = {
    return "Hola"
  }

  /** Verifica si una cadena es un palindromo.
    *
    * @param word  palabra a evaluar.
    * Return  true si lo es, false en otro caso.
    */
  def palindromo(word: String): Boolean = {
    var i = 0;
    var l = word.length() - 1;
    while(i < l){
      if(word.charAt(i) != word.charAt(l)){ return false }
      i += 1;
      l -= 1;
    }
    return true
  }

  /** Cuenta el número de repeticiones de un caracter en una palabra
    *
    * @param word  palabra a iterar
    * @param ch  caracter a buscar
    * Return  el número de apariciones del caracter
    */
  def repeticiones(ch: Char, word: String): Int = {
    var c = 0;
    for(i <- 0 to (word.length() -1) ){
      if(ch == word.charAt(i)){ c += 1; }
    }
    return c
  }

  /** Invierte una palabra
    *
    * @param word  palabra a invertir
    */
  def reversa(word: String): String ={
    var cadena: String = "";
    var i = 0;
    while(i < word.length()){
      cadena = word.charAt(i) + cadena;
      i += 1;
    }
    return cadena
  }
  
  def main(args: Array[String]): Unit = {
    println(hola());
    var word = scala.io.StdIn.readLine("Escribe una palabra   ")
    println("Es palindromo : "+ palindromo(word))
    print("Caracter a buscar  ")
    var ch = scala.io.StdIn.readChar()
    println("Repeticiones : "+ repeticiones(ch, word))
    println("palabra invertida   "+ reversa(word))
  }
}