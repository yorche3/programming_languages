object HelloUser {
  def main(args: Array[String]): Unit = {
    var name = scala.io.StdIn.readLine("Enter your name: ")
    println("Hello, "+ name +"!")
  }
}
