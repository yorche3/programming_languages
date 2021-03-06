#!/usr/bin/perl

use strict;
use warnings;

=begin comment
 * Declaración de la clase Punto
=end comment
=cut
package Punto{
    #=begin comment
    # * Constructor
    #=end comment
    #=cut
    sub new{
	my($class,$x,$y) = @_;
	my $punto = {
	    'x' => $x,
	    'y' => $y
	};
	bless $punto, $class;
	return $punto;
    }
};

=begin comment
 * Declaración de la clase Circulo
=end comment
=cut
package Circulo{
    sub new{
	my($class,$centro,$radio) = @_;
	my $self = {
	    'centro' => $centro,
	    'radio' => $radio
	};
	bless($self, $class);
	return $self;
    }
    # area del circulo
    sub area{
	my $self = shift;
	return $self->{'radio'} * $self->{'radio'};
    }
}

sub isInt{
    my $str = $_[0];
    if($str =~ /^(-)?[0-9]+$/){
        return 1;
    }
    return 0;
}

print "Valor de x   ";
my $cond = 1;
my $x = undef;
while($cond == 1){
    if(isInt(my $input = <>) == 1){
	$x = int(chomp($input));
	$cond = 0;
    }
}
my $y = undef;
print "Valor de y   ";
while($cond == 0){
    if(isInt(my $input = <>) == 1){
	$y = int(chomp($input));
	$cond = 1;
    }
}
my $r = undef;
print "Valor del radio   ";
while($cond == 1){
    if(isInt($r = <>) == 1){
	$cond = 0;
    }
}

my $p = Punto->new($x,$y);
my $c = Circulo->new($p,$r);
print $c->area() . "\n";
