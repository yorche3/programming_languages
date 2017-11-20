import java.util.Scanner;

public class Cadenas {

    /**
     * Constructor
     */
    public Cadenas(){
    }

    /**
     * @return cadena con un saludo
     *
     */
    public String hola(){
	return "Hola";
    }

    /**
     * Cuenta el número de repeticiones del caracter ch en la cadena str
     * 
     * @param ch caracter a buscar
     * @param str cadena sobre la que se buscará
     * @return un entero con el número de repeticiones
     */
    public int repeticiones(char ch, String str){
	int c = 0; //contador
	for(int i=0;i<str.length();i++){
	    if(str.charAt(i) == ch) c++;
	}
	return c;
    }

    /**
     * Verifica si la cadena word es palindromo
     *
     * @param word cadena a revisar
     * @return true si lo es, false en otro caso
     */
    public boolean palindromo(String word){
	int i = 0, l = word.length()-1;
	while(i < l){
	    if(word.charAt(i++) != word.charAt(l--)) return false;
	}
	return true;
    }

    /**
     * Invierte la palabra
     *
     * @param word cadena a invertir
     * @return una cadena con la palabra invertida
     */
    public String invertir(String word){
	String invStr = "";
	int l = word.length();
	int f = l-1;
	for(int i=0; i<l; i++){
	    invStr += word.charAt(f--);
	}
	return invStr;
    }

    public static void main(String [] args){
	Scanner scan = new Scanner(System.in);

	Cadenas c = new Cadenas();

	System.out.println(c.hola());
	System.out.print("Escribe una cadena   ");
	String word = scan.next();
	System.out.println("es palindromo :  "+ c.palindromo(word));
	System.out.print("¿Caracter a buscar?   ");
	char ch = scan.next().charAt(0);
	System.out.println("número de repeticiones : "+ c.repeticiones(ch, word));
	String invStr = c.invertir(word);
	System.out.println("cadena invertida  "+ invStr);
    }
}
