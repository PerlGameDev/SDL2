use strict;
use warnings;
use Test::More;

use SDL2::ConfigData;

BEGIN {
  plan skip_all => 'SDL2::Log not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2::Log'};
}


use SDL2::Log;

SDL2::Log::set_all_priority ( SDL_LOG_PRIORITY_VERBOSE );

is( SDL2::Log::get_priority( 0 ), SDL_LOG_PRIORITY_VERBOSE );

SDL2::Log::reset_priorities();

isnt( SDL2::Log::get_priority( 0 ), SDL_LOG_PRIORITY_VERBOSE );

SDL2::Log::log( "Foo %d" , 10);
pass('Log');
SDL2::Log::verbose( "Voo %d" , 10);
pass('Verbose');
SDL2::Log::debug( "Voo %d" , 10);
pass('Debug');
SDL2::Log::info( "Voo %d" , 10);
pass('Info');
SDL2::Log::warn( "Voo %d" , 10);
pass('Warn');
SDL2::Log::error( "Voo %d" , 10);
pass('Error');
SDL2::Log::message( "Voo %d" , 5, 10);
pass('Message');


done_testing();

