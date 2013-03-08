use strict;
use warnings;
use Test::More;

use SDL2::ConfigData;

BEGIN {
  plan skip_all => 'SDL2pp not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2pp'};
}


use SDL2pp;



done_testing;


