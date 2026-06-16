import std.stdio, std.string;

/++
 * @author   Jorge Eduardo Ascencio Esíndola
 * @version  v1.0
 ++/

/**
 * Regresa una cadena
 **/
string hello(){
  return "hola";
}

/**
 * Verifica si cadena es palindromo
 * 
 * @param cadena  cadena a verificar
 *
 * @return  true si es palindromo, false en otro caso
 **/
bool palindromo(string cadena){
  ulong l = cadena.length - 1;
  for(ulong i = 0; i < l; i++)
    if(cadena[i] != cadena[l--]) return false;
  return true;
}

/**
 * Invierte una cadena
 *
 * @param cadena  cadena a invertir
 *
 * @return la cadena invertida
 **/
string invertir(string cadena){
  ulong l = cadena.length;
  string inv_cadena = "";
  for(l--; l > 0; l--){
    inv_cadena ~= cadena[l];
  }
  inv_cadena ~= cadena[0];
  return inv_cadena;
}

/**
 * Cuenta el número de apariciones del cáracter c en cadena
 *
 * @param cadena   cadena que se iterara
 * @param c   cáracter a buscar
 *
 * @return   número de apariciones
 **/
uint repeticiones(string cadena, char c){
  uint cont = 0;
  for(int i = 0; i < cadena.length; i++)
    if(cadena[i] == c) cont++;
  return cont;
}

void main(){
  writeln(hello);
  string word;
  write("Escribe un palabra   ");
  word = strip(readln());
  writeln("¿Es palindromo? ",palindromo(word));
  char ch;
  writef("Cáracter a buscar   ");
  ch = readln()[0];
  writefln("repeticiones %c : %d", ch, repeticiones(word, ch));
  writeln("cadena invertida  "~invertir(word));
}