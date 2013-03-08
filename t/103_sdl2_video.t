use strict;
use warnings;
use Test::More;
use SDL2::ConfigData;

BEGIN {
  plan skip_all => 'SDL2::Video not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2::Video'};
}

use SDL2::Video;

can_ok('SDL2::Video', qw/get_current_video_driver/);

done_testing();
