object HelloConsole {
  def main(args: Array[String]): Unit = {
    var name = scala.io.StdIn.readLine("¿Cuál es tu nombre?   ")
    println("Hello "+ name)
  }
}
