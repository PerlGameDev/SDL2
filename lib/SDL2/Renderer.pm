package SDL2::Renderer;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL2::Internal::Loader;
if (check_and_load(__PACKAGE__)) {
  bootstrap SDL2::Renderer;
}
else {
  warn "WARNING: " . __PACKAGE__ . " is not available\n";
}

use SDL2::Constants ':SDL2::Renderer';
use base 'Exporter';

our @EXPORT = @{ $SDL2::Constants::EXPORT_TAGS{'SDL2::Renderer'} };

our %EXPORT_TAGS = (
    all     => \@EXPORT,
    type    => $SDL2::Constants::EXPORT_TAGS{'SDL2::Renderer/type'}
);


1;
