
use SDL2::Window;
use SDL2::Renderer;
use SDL2::Rect;
use SDL2::Texture;

BEGIN {
use SDL2::ConfigData;

  plan skip_all => 'SDL2::Texture not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2::Texture'};

}

ok( exists &SDL2::Texture::new, 'new exists');

exit 0 if SDL2pp::init(SDL_INIT_VIDEO) < 0 ; #SDL_INIT_VIDEO

my $win = SDL2::Window->new("FIRST WINDOW", 50, 50, 200, 200, SDL_WINDOW_SHOWN );

my $renderer = SDL2::Renderer->new($win, -1, SDL_RENDERER_SOFTWARE); #Hardware accelerated with software fallback


can_ok('SDL2::Texture', qw/new/);

my $texture = SDL2::Texture->new($renderer, 1, 1, 100, 100);

done_testing();
