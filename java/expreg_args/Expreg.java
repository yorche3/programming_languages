/**
 * @author   Jorge Eduardo Ascencio Espíndola
 * @version  v1.0
 */
public class Expreg{

    /**
     * Constructor
     */
    public Expreg(){
    }

    /**
     * Verifica si la cadena str cumple con la expresión regular
     *
     * @param str  cadena a evaluar
     *
     * return true si es valida, false en otro caso
     */
    public boolean match(String str){
	return str.matches("[A-Z]([a-z]|ñ){1,5}"); // verifica si cumple con la expresion regular
    }

    public static void main(String [] args){
	if(args.length != 1){
	    System.out.println("Recibe un solo argumento\nDebe ser de la forma");
	} else {
	    Expreg expr = new Expreg();
	    if(expr.match(args[0])){
		System.out.println("Felicidades la cadena es valida!");
	    } else {
		System.out.println("La cadena no es correcta");
	    }
	}
	System.out.println("Cerrando programa ...");
    }
}
