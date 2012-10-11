# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'SDL2' ); }

my $object = SDL2->new ();
isa_ok ($object, 'SDL2');


