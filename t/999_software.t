# -*- perl -*-

use Test::More tests => 10;

BEGIN { 
    use_ok( 'SDL2pp' );
    use_ok( 'SDL2::Window' );
    use_ok( 'SDL2::Renderer' );
    use_ok( 'SDL2::Rect' );
}

exit 0 if SDL2pp::init(SDL_INIT_VIDEO) < 0 ; #SDL_INIT_VIDEO

my $win = SDL2::Window->new("FIRST WINDOW", 50, 50, 200, 200, SDL_WINDOW_SHOWN );

my $renderer = SDL2::Renderer->new($win, -1, 0x00000001); #Hardware accelerated with software fallback

my $rect = SDL2::Rect->new(0,0,4,4);

is($renderer->set_draw_color(0,0,0,255), 0, "Can set draw color" );

is($renderer->clear(), 0, "Can clear renderer");

is($renderer->set_draw_color(0, 255,0,255), 0, "Can change draw color");

is($renderer->fill_rect($rect), 0, "Can fill rect");

my $rect2 = SDL2::Rect->new(4,4,10,10);

is($renderer->draw_rect($rect2), 0, "Can draw rect");

$renderer->present();

SDL2pp::delay(3000);

SDL2pp::quit();
warn "FINISHED: ". SDL2pp::get_error();

pass();
