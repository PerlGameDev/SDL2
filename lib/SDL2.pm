package SDL2;
use strict;
use warnings;
use SDL2pp;
use vars qw($VERSION $XS_VERSION @ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL2::Constants ':SDL2';

use base 'Exporter';
our @EXPORT = @{ $SDL2::Constants::EXPORT_TAGS{SDL2} };
push @EXPORT, 'NULL';
our %EXPORT_TAGS = (
    all      => \@EXPORT,
    init     => $SDL2::Constants::EXPORT_TAGS{'SDL2/init'},
    hint     =>  $SDL2::Constants::EXPORT_TAGS{'SDL2/hint'}

);


our $VERSION    = '0.01';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

sub init {
    return SDL2pp::init(@_);
}

sub quit {
    return SDL2pp::quit(@_);
}
1;
