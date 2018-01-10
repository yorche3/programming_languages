use std::io;

fn main() {
   println!("¿Cuál es tu nombre?   ");
   let mut name = String::new();
   match io::stdin().read_line(&mut name) {
      Ok(_n) => {
	 print!("Hola {}", name);
      }
      Err(error) => println!("error: {}", error),
   }
}