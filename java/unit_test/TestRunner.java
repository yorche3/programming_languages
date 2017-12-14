import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.junit.runner.notification.Failure;
import org.junit.runner.notification.RunListener;
import org.junit.runner.Description;

class MyListener extends RunListener {
    public void testRunStarted(Description description) throws java.lang.Exception{
	System.out.println("Inicio....\nNúmero de pruebas a realizar: "+ description.testCount());
    }
    public void testRunFinished(Result result) throws java.lang.Exception{
	System.out.println("Total de pruebas ejecutadas : "+ result.getRunCount());
    }
    public void testStarted(Description description) throws java.lang.Exception{
	System.out.print("Ejecución de prueba : "+ description.getMethodName()+ " .......... ");
    }
    public void testFinished(Description description) throws java.lang.Exception{
	System.out.println("finalizada : OK");
    }
    public void testFailure(Failure failure) throws java.lang.Exception{
	System.out.println("falló : "+ failure.getMessage());
    }
}

public class TestRunner{
    public static void main(String[] args) {
	JUnitCore core= new JUnitCore();
	core.addListener(new MyListener());
	Result result = core.run(BasicMathTest.class);
	for (Failure failure : result.getFailures()) {
	    System.out.println(failure.toString());
	}
	System.out.println("Test: "+ (result.wasSuccessful() == true ? "Ok" : "Failure")+ ", "+ result.getRunTime()+ " miliseconds");
    }
}  	
