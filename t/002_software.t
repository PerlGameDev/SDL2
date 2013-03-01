# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 5;

BEGIN { 
    use_ok( 'SDL2pp' );
    use_ok( 'SDL2::Window' );
    use_ok( 'SDL2::Renderer' );
    use_ok( 'SDL2::Rect' );
     }

exit 0 if SDL2pp::init(0x00000020) < 0 ; #SDL_INIT_VIDEO

my $window_flags => {     SDL_WINDOW_FULLSCREEN => 0x00000001, 
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

my $win = SDL2::Window->new("FIRST WINDOW", 50, 50, 200, 200, $window_flags->{SDL_WINDOW_SHOWN} );

my $renderer = SDL2::Renderer->new($win, -1, 0x00000001); #Hardware accelerated with software fallback

my $rect = SDL2::Rect->new(0,0,4,4);

warn $renderer->set_draw_color(255,0,0,255);

warn $renderer->clear();

warn $renderer->set_draw_color(0, 255,0,255);

warn $renderer->fill_rect($rect);

my $rect2 = SDL2::Rect->new(4,4,10,10);

warn $renderer->draw_rect($rect);

SDL2pp::delay(3000);

SDL2pp::quit();
warn "FINISHED: ". SDL2pp::get_error();

pass();
