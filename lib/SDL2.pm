package SDL2;
use strict;
use warnings;
use SDL2pp;
use vars qw($VERSION $XS_VERSION @ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

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
