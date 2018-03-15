use std::io;

/// hola
/// # returns  un saludo
fn hola(_x: &str) -> &str {
  return "Hola";
}

/// palindromo
/// Verifica si una palabra es palindromo
///
/// # params
/// _word  palabra a evaluar
///
/// #returns  true si lo es, false en otro caso	
fn palindromo(word: String) -> bool {
  let mut i = 0;
  let mut l = word.len() - 2;
  let cad: Vec<char> = word.chars().collect();
  loop {
    println!("{} ? {}", cad[i], cad[l]);
    if cad[i] != cad[l] { return false; }
    i += 1;
    l -= 1;
    if i >= l { break; }
  }
  return true;
}

/// repeticiones
/// Cuenta el número de repeticiones de un caracter en una palabra
///
/// #params
/// _ch  caracter a buscar
/// _word  palabra a iterar
///
/// #returns  el número de apariciones de ch en word
fn repeticiones(word: String, ch: char) -> i32 {
  let mut i = 0;
  let l = word.len() - 1;
  let mut count = 0;
  let cad: Vec<char> = word.chars().collect();
  loop {
    if cad[i] == ch { count += 1; }
    i += 1;
    if i == l { break; }
  }
  return count;
}

/// reversa
///
/// # params
/// _word : &str   palabra a invertir
/// 
/// # returns  la palabra invertida
fn reversa(word: String) -> String {
  return word.chars().rev().collect::<String>();
}

fn main() {
   println!("{}", hola(""));
   let mut word = String::new();
   println!("Escribe una palabra");
   match io::stdin().read_line(&mut word) {
     Ok(_n) => {
       println!("Es palindromo {}", palindromo(word.clone()));
       let mut cha = String::new();
       println!("Caracter a buscar");
       match io::stdin().read_line(&mut cha) {
         Ok(_n) => {
	   let ch: Vec<char> = cha.chars().collect();
	   println!("repeticiones : {}", repeticiones(word.clone(), ch[0]));
	 }
	 Err(error) => println!("error: {}", error),
       }
       println!("Palabra invertida {}", reversa(word.clone()));	 
     }
     Err(error) => println!("error: {}", error),
   }
}
