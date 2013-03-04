package SDL2::Internal::Loader;
use strict;
use warnings;
use vars qw($VERSION @ISA @EXPORT @LIBREFS);
require Exporter;
our @ISA     = qw(Exporter);
our @EXPORT  = qw(check_and_load);
our @LIBREFS = ();

our $VERSION = '0.01';
$VERSION = eval $VERSION;

use SDL2::ConfigData;
use Alien::SDL2;

# SDL2::Internal::Loader is a king of "Dynaloader kung-fu" that is
# necessary in situations when you install Allien::SDL2 from sources
# or from prebuilt binaries as in these scenarios the SDL2 stuff is
# installed into so called 'sharedir' somewhere in perl/lib/ tree
# on Windows box it is e.g.
# C:\strawberry\perl\site\lib\auto\share\dist\Alien-SDL2...
#
# What happens is that for example XS module "SDL2::Video" is linked
# with -lSDL2 library which means that resulting "Video.(so|dll)" has
# a dependency on "libSDL2.(so|dll)" - however "libSDL2.(so|dll)" is
# neither in PATH (Win) or in LD_LIBRARY_PATH (Unix) so Dynaloader
# will fail to load "Video.(so|dll)".

sub check_and_load($) {
  my $package = shift;

  ### get list of lib nicknames based on packagename
  my $lib_nick = SDL2::ConfigData->config('mod2lib')->{$package};
  return 0 unless $lib_nick;  # $package is disabled (XS is not compiled)
        
  ### get lib to DLL fullname mapping
  my $shlib_map = Alien::SDL2->config('ld_shlib_map');
  return 1 unless $shlib_map; # empty shlib_map, nothing to do

  ### let us load the corresponding shlibs (*.dll|*.so)
  require DynaLoader;
  foreach my $n (@$lib_nick) {
    my $file = $shlib_map->{$n};
    next unless $file && -e $file;
    my $libref = DynaLoader::dl_load_file($file, 0);
    push( @DynaLoader::dl_librefs, $libref ) if $libref;
    push( @LIBREFS,                $libref ) if $libref;
  }
  return 1;
}

1;
