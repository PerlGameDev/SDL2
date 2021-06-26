#!/usr/bin/env perl

use Test2::V0;
use SDL2::Raw;

skip_all 'No video support' if SDL2::Init( SDL2::INIT_VIDEO ) < 0;

my $window = SDL2::CreateWindow(
    'FIRST WINDOW',
    SDL2::WINDOWPOS_UNDEFINED,
    SDL2::WINDOWPOS_UNDEFINED,
    200, 200,
    SDL2::WINDOW_HIDDEN,
) or die 'Error creating SDL window: ' . SDL2::GetError;

my $renderer = SDL2::CreateRenderer( $window, -1, SDL2::RENDERER_SOFTWARE )
    or die 'Error creating SDL renderer: ' . SDL2::GetError;

my $rect = SDL2::Rect->new( 0, 0, 4, 4 );

is SDL2::SetRenderDrawColor( $renderer, 0, 0, 0, 0xff ), 0,
    'Can set draw color';

is SDL2::RenderClear($renderer), 0, 'Can clear renderer';

is SDL2::SetRenderDrawColor( $renderer, 0, 0xff, 0, 0xff ), 0,
    'Can change draw color';

is SDL2::RenderFillRect( $renderer, $rect ), 0, 'Can fill rect';

my $rect2 = SDL2::Rect->new( 4, 4, 10, 10 );

is SDL2::RenderDrawRect( $renderer, $rect2 ), 0, 'Can draw rect';

SDL2::RenderPresent($renderer);

SDL2::Quit;

diag 'FINISHED: ' . ( SDL2::GetError || 'No error' );

done_testing;
