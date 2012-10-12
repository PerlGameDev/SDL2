# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'SDL2' ); }

SDL2::init(0);

SDL2::quit();

pass();
