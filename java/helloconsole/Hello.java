import java.util.Scanner;

public class Hello{

    public static void main(String [] args){
	Scanner scanner = new Scanner(System.in);

	System.out.print("¿Cuál es su nombre?   ");
	String name = scanner.nextLine();

	System.out.println("Hola  "+name+"!");
    }
}
    
