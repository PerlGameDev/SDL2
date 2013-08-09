use strict;
use warnings;
use Test::More;
use SDL2::ConfigData;

BEGIN {
  plan skip_all => 'SDL2::Texture not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2::Texture'};
}

use SDL2::Texture;

ok( exists &SDL2::Texture::new, 'new exists');

can_ok('SDL2::Texture', qw/new/);

done_testing();
