#!/usr/bin/perl
=begin comment
=end comment
=cut
sub match{
    $str = $_[0];
    if($ARGV[0] =~ /^[A-Z]([a-z]|ñ){1,5}$/){
	return 1;
    }
    return 0;
}

if($#ARGV + 1 != 1){
    print "Recibe un solo argumento\nDebe ser de la forma : \n";
} else {
    if(match($ARGV[0])){
	print "Felicidades la cadena es valida!\n";
    } else {
	print "La cadena no es correcta\n";
    }
}
print "Cerrando programa ...\n"
