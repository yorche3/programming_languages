class Cadenas : GLib.Object {

  public Cadenas(){}
  
  public string hola(){
    return "Hola\n";
  }

  public string palindromo(string word){
    int i = 0, l = word.length - 1;
    while(i < l){
      if(word[i] != word[l]) return "false";
      i++;
      l--;
    }
    return "true";
  }

  public int repeticiones(string word, unichar ch){
    int r = 0;
    for(int i = 0; i < word.length; i++){
      uint8 cc = word[i];
      if(cc == ch) r++;
    }
    return r;
  }
  
  public static int main(string[] args) {
    Cadenas cad = new Cadenas();
    stdout.printf (cad.hola ());
    stdout.printf ("Escribe una palabra   ");
    string? word = stdin.read_line ();
    if (word == null) {
      return 1;
    }
    stdout.printf ("Es palindromo : %s\n", cad.palindromo(word));
    stdout.printf ("caracter a buscar   ");
    string? car = stdin.read_line ();
    if (car == null){
      return 1;
    }
    unichar ch = car[0];
    stdout.printf ("repeticiones = %d\n", cad.repeticiones (word, ch));
    
    return 0;
  }
}