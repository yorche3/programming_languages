import spock.lang.Specification

class NumericalSpec extends Specification {
  
  def setupSpec() {
  }

  def "fibonacci"() {
    expect:
    Numerical.fibonacci(n) == result

    where:
    n || result
    -3 || -1
    10 || 55
    15 || 610
  }

  def "factorial"() {
    expect:
    Numerical.factorial(n) == result

    where:
    n || result
    -3 || -1
    5 || 120
    10 || 3628800
  }

  def "greatest common divisor"() {
    expect:
    Numerical.gcd(a, b) == result

    where:
    a || b || result
    48 || 18 || 6
    100 || 25 || 25
    17 || 13 || 1
  }

  def "lowest common divisor"() {
    expect:
    Numerical.lcm(a, b) == result

    where:
    a || b || result
    4 || 6 || 12
    21 || 6 || 42
    7 || 3 || 21
  }
}