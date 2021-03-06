(**ocaml cadenas
1;2802;0c1;2802;0c1;2802;0c1;2802;0c   @author  Jorge Eduardo Ascencio Espíndola
   @version v1.0.*)

(**Regresa un saludo*)
let hola () = "Hola";;

(**Verifica si una palabra es palindromo
   @param word  palabra a evaluar
   @return true si lo es, false en otro caso*)
let palindromo word =
  let l = String.length word in
    let rec comp n =
        n = 0 || (word.[l-n] = word.[n-1] && comp (n-1)) in
    comp (l / 2);;

(**Cuenta el número de repeticiones de un carácter en una palabra
   @param word  palabra a iterar
   @param ch  carácter a buscar
   @return  el número de apariciones*)
let repeticiones word ch =
  let c = ref 0 in
  for i = 0 to ((String.length word) - 1) do
    if word.[i] = ch then
      c := !c + 1;
  done;
  !c;;

(**Invierte una palabra*)
let string_rev s =
  let len = String.length s in
  String.init len (fun i -> s.[len - 1 - i]);;
 
let () =
  print_endline (string_rev "Hello world!")

let () = Printf.printf "%s\n" (hola ())
let () = Printf.printf "%B\n" (palindromo "ababa")
let () = Printf.printf "%d\n" (repeticiones "ababa" 'a')
