use strict;
use warnings;
use Test::More;
use SDL2::ConfigData;

BEGIN {
  plan skip_all => 'SDL2::Window not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2::Window'};
}

use SDL2::Window;

ok( exists &SDL2::Window::new, 'new exists');
can_ok('SDL2::Window', qw/new/);

ok 1, 'success 1';
ok 1, 'success 2';

done_testing();
