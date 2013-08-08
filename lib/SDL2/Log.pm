package SDL2::Log;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;

use SDL2::Constants ':SDL2::Log';
our @ISA = qw(Exporter DynaLoader);

use SDL2::Internal::Loader;
if (check_and_load(__PACKAGE__)) {
  bootstrap SDL2::Log;
}
else {
  warn "WARNING: " . __PACKAGE__ . " is not available\n";
}

use base 'Exporter';

our @EXPORT = @{ $SDL2::Constants::EXPORT_TAGS{'SDL2::Log'} };

our %EXPORT_TAGS = (
    all     => \@EXPORT,
    priority    => $SDL2::Constants::EXPORT_TAGS{'SDL2::Log/type'}
);

1;
