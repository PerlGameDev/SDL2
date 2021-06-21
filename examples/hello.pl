#!/usr/bin/env perl

use strict;
use warnings;

use SDL2::Raw;
use File::Share 'dist_file';

# Simple example for using SDL2 directly

SDL2::Init( SDL2::INIT_VIDEO )
    and die 'Could not initialise SDL2: ' . SDL2::GetError;

my $window = SDL2::CreateWindow(
    'Hello World',
    SDL2::WINDOWPOS_CENTERED,
    SDL2::WINDOWPOS_CENTERED,
    592,
    460,
    SDL2::WINDOW_SHOWN,
) or die "Error creating SDL window: " . SDL2::GetError;

my $image = SDL2::LoadBMP( dist_file 'SDL2-Raw', 'hello.bmp' )
    or die 'Error loading image: ' . SDL2::GetError;

my $surface = SDL2::GetWindowSurface($window)
    or die 'Error getting window surface: ' . SDL2::GetError;

SDL2::BlitSurface( $image, undef, $surface, undef )
    and die 'Could not blit surface: ' . SDL2::GetError;

SDL2::UpdateWindowSurface($window)
    and die 'Could not update window surface: ' . SDL2::GetError;

SDL2::FreeSurface($image);

my $event = SDL2::Event->new;
MAIN: while (1) {
    while ( SDL2::PollEvent($event) ) {
        last MAIN if $event->type == SDL2::QUIT;
    }

    SDL2::Delay(10);
}

SDL2::DestroyWindow($window);
SDL2::Quit;
