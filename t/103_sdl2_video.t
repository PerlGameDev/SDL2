use strict;
use warnings;
use Test::More;
use SDL2::ConfigData;

BEGIN {
  plan skip_all => 'SDL2::Video not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2::Video'};
}

use SDL2::Video;

can_ok('SDL2::Video', qw/get_current_video_driver get_num_video_drivers get_video_driver/);

SDL2::Video::get_current_video_driver();
pass();

foreach( 0..SDL2::Video::get_num_video_drivers() )
{
   SDL2::Video::get_video_driver($_);
   pass();
}
pass();


done_testing();
