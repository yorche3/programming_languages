#!/usr/bin/perl

=begin comment
-regresa una cadena con un saludo
=end comment
=cut
sub Hola{
    return "Hola";
}

=begin comment
=end comment
=cut
sub Palindromo{
    $i = 0;
    $f = length $_[0] - 1;
    if(substr($_[0], $i, $i) ne substr($_[0], $f, $f)){
	return 0;
    }
    return 1;
}

$saludo = Hola();
print "$saludo\n";
print "Escribe una palabra   ";
$word = <>;
$es_palindromo = Palindromo($word);
print "Es palindromo  $es_palindromo\n";
