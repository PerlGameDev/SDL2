use strict;
use warnings;

use SDL2;

SDL2::Init( SDL2::INIT_VIDEO )
    and die SDL2::GetError;

my $window = SDL2::CreateWindow(
    'FIRST WINDOW',
    50, 50,
    200, 200,
    SDL2::WINDOW_SHOWN | SDL2::WINDOW_OPENGL,
) or die SDL2::GetError;

my $renderer = SDL2::CreateRenderer(
    $window,
    -1,
    SDL2::RENDERER_ACCELERATED, #Hardware accelerated with software fallback
) or die SDL2::GetError;

SDL2::SetRenderDrawColor( $renderer, 0, 0, 0, 255 )
    and die SDL2::GetError;

SDL2::RenderClear( $renderer )
    and die SDL2::GetError;

SDL2::SetRenderDrawColor( $renderer, 255, 255, 0, 255 )
    and die SDL2::GetError;

my $rect = SDL2::Rect->new( 0, 0, 10, 10 );

SDL2::RenderDrawRect( $renderer, $rect )
    and die SDL2::GetError;

SDL2::RenderPresent( $renderer )
    and die SDL2::GetError;

SDL2::DestroyRenderer( $renderer );
SDL2::DestroyWindow( $window );

SDL2::Quit;
