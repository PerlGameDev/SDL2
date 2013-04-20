package SDL2::Window;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;

use SDL2::Constants ':SDL2::Window';
our @ISA = qw(Exporter DynaLoader);



use SDL2::Internal::Loader;
if (check_and_load(__PACKAGE__)) {
  bootstrap SDL2::Window;
}
else {
  warn "WARNING: " . __PACKAGE__ . " is not available\n";
}

use base 'Exporter';

our @EXPORT = @{ $SDL2::Constants::EXPORT_TAGS{'SDL2::Window'} };

our %EXPORT_TAGS = (
    all     => \@EXPORT,
    type    => $SDL2::Constants::EXPORT_TAGS{'SDL2::Window/type'}
);

1;
