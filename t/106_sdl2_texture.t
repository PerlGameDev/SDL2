use Test::More tests => 3;
use SDL2pp;
use SDL2::Window;
use SDL2::Renderer;
use SDL2::Rect;
use SDL2::Texture;
use SDL2::ConfigData;
use SDL2::Constants;

BEGIN {

  plan skip_all => 'SDL2::Texture not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2::Texture'};

}


exit 0 if SDL2pp::init(SDL_INIT_VIDEO) < 0 ; #SDL_INIT_VIDEO

my $win = SDL2::Window->new("FIRST WINDOW", 50, 50, 200, 200, SDL_WINDOW_SHOWN );

my $renderer = SDL2::Renderer->new($win, -1, SDL_RENDERER_SOFTWARE); #Hardware accelerated with software fallback

can_ok('SDL2::Texture', qw/new/);

my $texture = SDL2::Texture->new($renderer, SDL_PIXELFORMAT_RGB332, SDL_TEXTUREACCESS_STATIC, 100, 100);
fail( SDL2pp::get_error() ) unless $texture;
my $texture2 = SDL2::Texture->new($renderer, SDL_PIXELFORMAT_RGB565, SDL_TEXTUREACCESS_STREAMING, 100, 100);
fail( SDL2pp::get_error() ) unless $texture2;

isa_ok($texture, 'SDL2::Texture');

isa_ok($texture2, 'SDL2::Texture');


