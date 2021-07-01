use strict;
use warnings;

use Benchmark qw(:all);

# SET UP THREE THINGS
# SDL
#

my $draw_sdl = sub {
    `perl scripts/bench_sdl.pl`;
};

my $draw_sdl2 = sub {
    `perl -Ilib scripts/bench_sdl2.pl`;
};

cmpthese( 500, { sdl => $draw_sdl , sdl2 =>  $draw_sdl2 } );
