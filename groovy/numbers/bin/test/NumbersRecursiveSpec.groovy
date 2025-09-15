import spock.lang.Specification

class NumbersRecursiveSpec extends Specification {

    static NumbersRecursive numbersRecursive

    def setupSpec() {
        numbersRecursive = new NumbersRecursive()
    }

    def "fibonacci of a number"() {
        expect:
        numbersRecursive.fibonacci(n) == result

        where:
        n || result
        5 || 5
    }

    def "factorial of a number"() {
        expect:
        numbersRecursive.factorial(n) == result

        where:
        n || result
        5 || 120
    }

    def "sum of first n natural numbers"() {
        expect:
        numbersRecursive.sumNumbers(n) == result

        where:
        n || result
        5 || 15
    }
}