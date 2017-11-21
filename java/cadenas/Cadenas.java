import java.util.Scanner;


/**
* @author    Jorge Eduardo Ascencio Espíndola
* @version   v1.0
*/
public class Cadenas {

    /**
     * Constructor
     */
    public Cadenas(){
    }

    /**
     * @return cadena con un saludo
     */
    public String hola(){
	return "Hola";
    }

    /**
     * Cuenta el número de repeticiones del caracter ch en la cadena str
     * 
     * @param ch caracter a buscar
     * @param str cadena sobre la que se buscará
     *
     * @return un entero con el número de repeticiones
     */
    public int repeticiones(char ch, String str){
	int c = 0; //contador
	for(int i=0;i<str.length();i++){
	    if(str.charAt(i) == ch) c++; // comparar caracteres
	}
	return c;
    }

    /**
     * Verifica si la cadena word es palindromo
     *
     * @param word cadena a revisar
     *
     * @return true si lo es, false en otro caso
     */
    public boolean palindromo(String word){
	int i = 0, l = word.length()-1;
	while(i < l){
	    if(word.charAt(i++) != word.charAt(l--)) return false; // obtener caracter de una posicion de la cadena
	}
	return true;
    }

    /**
     * Invierte la palabra
     *
     * @param word cadena a invertir
     *
     * @return una cadena con la palabra invertida
     */
    public String invertir(String word){
	String invStr = "";
	int l = word.length();
	int f = l-1;
	for(int i=0; i<l; i++){
	    invStr += word.charAt(f--); // concatenar cadena caracter
	}
	return invStr;
    }

    public static void main(String [] args){
	Scanner scan = new Scanner(System.in); // scanner para el ingreso estandar

	Cadenas c = new Cadenas();

	System.out.println(c.hola());
	System.out.print("Escribe una cadena   "); // imprimir en cosola
	String word = scan.next(); // obtener linea de entrada desde consola
	System.out.println("es palindromo :  "+ c.palindromo(word));
	System.out.print("¿Caracter a buscar?   ");
	char ch = scan.next().charAt(0); // obtener caracter desde consola
	System.out.println("número de repeticiones : "+ c.repeticiones(ch, word));
	String invStr = c.invertir(word);
	System.out.println("cadena invertida  "+ invStr); // concatenar cadena de impresión
    }
}
