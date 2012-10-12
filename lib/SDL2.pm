package SDL2;
use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

our $VERSION    = '0.01';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

use SDL2::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL2;

use base 'Exporter';

1;
