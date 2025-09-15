import spock.lang.Specification

class NumbersIterativeSpec extends Specification {

    static NumbersIterative numbersIterative

    def setupSpec() {
        numbersIterative = new NumbersIterative()
    }

    def "fibonacci of a number"() {
        expect:
        numbersIterative.fibonacci(n) == result

        where:
        n || result
        5 || 5
    }

    def "factorial of a number"() {
        expect:
        numbersIterative.factorial(n) == result

        where:
        n || result
        5 || 120
    }

    def "sum of first n natural numbers"() {
        expect:
        numbersIterative.sumNumbers(n) == result

        where:
        n || result
        5 || 15
    }
}