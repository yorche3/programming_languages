import spock.lang.Specification

class CalculatorSpec extends Specification {
    def "test addition"() {
        given:
        def calc = new Calculator()

        expect:
        calc.add(1, 2) == 3
    }

    def "test subtraction"() {
        given:
        def calc = new Calculator()

        expect:
        calc.subtract(5, 3) == 2
    }
}