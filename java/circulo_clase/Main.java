import java.util.Scanner;
import java.lang.Math;
import java.lang.RuntimeException;
import java.util.InputMismatchException;

/**
 * @author  Jorge Eduardo Ascencio Espíndola
 * @version v1.0
 */
class Circulo{
    /**
     * Clase privada Punto, solo la usara la clase Circulo
     */
    class Punto{
        private int x; // valor en el eje X
	private int y; // valor en el eje Y

	/**
	 * Contructor
	 */
        public Punto(int x, int y){
            this.x = x;
            this.y = y;
        }

        /**
	 * @return  el valor de x
	 */
        public int getX(){
            return this.x;
        }

        /**
	 * @return  el valor de y
	 */
        public int getY(){
            return this.y;
        }
    }

    private Punto centro;
    private double radio;

    /**
     * Constructores
     */
    public Circulo(){}
    public Circulo(Punto p, double r){
	this.centro = p;
	this.radio = r;
    }

    /**
     * Cálcula el área del circulo
     *
     * @return  el valor del área
     */
    public double area(){
	return Math.PI * this.radio * this.radio;
    }
}

public class Main{
    public static void main(String [] args){
	Scanner sc = new Scanner(System.in);
	int x;
	System.out.print("valor de x:   ");
        while (!sc.hasNextInt()){
	    String input = sc.next();
        }
        x = sc.nextInt();
	int y;
	System.out.print("valor de y:   ");
        while(!sc.hasNextInt()){
	    String input = sc.next();
	}
	y = sc.nextInt();
	double r;
        System.out.print("valor del radio:   ");
	while(!sc.hasNextDouble()){
	    String input = sc.next();
	}
	r = sc.nextDouble();
	Circulo aux = new Circulo();
	Circulo c = new Circulo(aux.new Punto(x, y), r);
	System.out.println("area: "+ c.area());
    }
}
