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

my $displaymode = SDL2::DisplayMode->new(10,10,60);

isa_ok($displaymode, 'SDL2::DisplayMode', 'new makes an SDL2::DisplayMode');

ok 1, 'success 1';
ok 1, 'success 2';

done_testing();
