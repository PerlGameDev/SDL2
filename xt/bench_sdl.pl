use strict; 
use warnings;
use SDL;
use SDLx::App;

my $app = SDLx::App->new( eoq => 1 , w => 200, h => 200);

    $app->draw_rect( [0,0,200,200], 0x000000FF );

    $app->draw_rect( [0,0,10,10], 0xFFFF00FF );

    $app->update();

