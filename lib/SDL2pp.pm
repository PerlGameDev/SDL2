package SDL2pp;
use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

our $VERSION    = '0.01';
our $XS_VERSION = 0;
$VERSION = eval $VERSION;

use SDL2::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL2pp;

use base 'Exporter';

1;
