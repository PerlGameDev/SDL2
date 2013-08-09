use strict;
use warnings;

use Test::More tests => 1;

diag( "Testing SDL2 $SDL2::VERSION, Perl $], $^X" );

my $ok;
END { BAIL_OUT "Could not load all modules" unless $ok }

use SDL2;
use SDL2::ConfigData;
use SDL2pp;
use SDL2::Window;
use SDL2::Renderer;
use SDL2::Rect;
use SDL2::Texture;
use SDL2::Video;
use SDL2::Constants;
use SDL2::Log;
#add more

ok 1, 'All modules loaded successfully';
$ok = 1;
