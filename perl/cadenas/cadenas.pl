#!/usr/bin/perl

=begin comment
Genera una cadena con un saludo

@return una cadena
=end comment
=cut
sub Hola{
    return "Hola";
}

=begin comment
Verifica si una cadena es palindromo

@param _[0] : cadena

@return 1 si lo es, 0 en otro caso
=end comment
=cut
sub Palindromo{
    my @arr = split //, $_[0];
    $i = 0;
    $f = length $_[0];
    $f--;
    while($i < $f){
	$char1 = $arr[$i];
        $char2 = $arr[$f];
	if($char1 ne $char2){
	    return 0;
	}
	$i++;
	$f--;
    }
    return 1;
}

=begin comment
Cuenta el número de repeticiones de un caracter en una cadena

@param $_[0] : caracter
@param $_[1] : cadena

@return c un entero con el conteo
= end comment
=cut
sub Repeticiones{
    my @arr = split //, $_[1];
    $i = 0;
    $l = length $_[1];
    $c = 0;
    my $char = substr($_[0],0,1);
    while($i < $l){
	$c_char = $arr[$i];
	if($char eq $c_char){
	    $c++;
	}
	$i++;
    }
    return $c;
}

$saludo = Hola();
print "$saludo\n";
print "Escribe una palabra   ";
chomp ($word = <>);
$es_palindromo = Palindromo($word);
print "Es palindromo  $es_palindromo\n";
print "Caracter a buscar :   ";
$char = <>;
$num_repeticiones = Repeticiones($char, $word);
print "repeticiones : $num_repeticiones\n";
