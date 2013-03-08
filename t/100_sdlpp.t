use strict;
use warnings;
use Test::More;

use SDL2::ConfigData;

BEGIN {
  plan skip_all => 'SDL2pp not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2pp'};
}


use SDL2pp;

pass('Loaded');

can_ok('SDL2pp', qw/ 
    init
    init_sub_system
    delay
    quit_sub_system
    quit
    was_init
    clear_hints
    get_hint
    set_hint
    set_hint_with_priority
    get_error  
/);


done_testing;


