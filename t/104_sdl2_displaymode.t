use strict;
use warnings;
use Test::More;
use SDL2::ConfigData;

BEGIN {
  plan skip_all => 'SDL2::DisplayMode not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2::DisplayMode'};
}

use SDL2::DisplayMode;

ok( exists &SDL2::DisplayMode::new, 'new exists');

can_ok('SDL2::DisplayMode', qw/new/);

my $dm = SDL2::DisplayMode->new(10,10,60);

is( $dm->w, 10 );

is( $dm->h, 10 );

is( $dm->refresh_rate, 60);

isa_ok($dm, 'SDL2::DisplayMode', 'new makes an SDL2::DisplayMode');

done_testing();
