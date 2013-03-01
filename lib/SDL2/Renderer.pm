package SDL2::Renderer;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL2::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL2::Renderer;

use base 'Exporter';

1;
