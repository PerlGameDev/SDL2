use strict;
use warnings;

use SDL2pp;
use SDL2::Window;
use SDL2::Renderer;
use SDL2::Rect;

SDL2pp::init(0x00000020); 
my $window_flags = {     SDL_WINDOW_FULLSCREEN => 0x00000001, 
    SDL_WINDOW_OPENGL => 0x00000002, 
    SDL_WINDOW_SHOWN => 0x00000004, 
    SDL_WINDOW_HIDDEN => 0x00000008, 
    SDL_WINDOW_BORDERLESS => 0x00000010,
    SDL_WINDOW_RESIZABLE => 0x00000020,
    SDL_WINDOW_MINIMIZED => 0x00000040,
    SDL_WINDOW_MAXIMIZED => 0x00000080,
    SDL_WINDOW_INPUT_GRABBED => 0x00000100,
    SDL_WINDOW_INPUT_FOCUS => 0x00000200,
    SDL_WINDOW_MOUSE_FOCUS => 0x00000400,
    SDL_WINDOW_FULLSCREEN_DESKTOP => (  0x00000001 | 0x00001000 ),
    SDL_WINDOW_FOREIGN => 0x00000800 
};

my $win = SDL2::Window->new("FIRST WINDOW", 50, 50, 200, 200, $window_flags->{SDL_WINDOW_SHOWN} | $window_flags->{SDL_WINDOW_OPENGL});

my $renderer = SDL2::Renderer->new($win, -1, 0x00000002); #Hardware accelerated with software fallback



 $renderer->set_draw_color(0,0,0,255);

 $renderer->clear();

 $renderer->set_draw_color(255, 255,0,255);

 my $rect2 = SDL2::Rect->new(0,0,10,10);

 $renderer->draw_rect( $rect2 );

 $renderer->present();
SDL2pp::quit();



