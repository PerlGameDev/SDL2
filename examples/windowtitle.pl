#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say state );

use SDL2::Raw;

say 'This demo should dynamically set the window title';

SDL2::Init( SDL2::INIT_VIDEO )
    and die 'Could not initialise SDL2: ' . SDL2::GetError;

my $window = SDL2::CreateWindow(
    'This will surely be overwritten',
    SDL2::WINDOWPOS_UNDEFINED,
    SDL2::WINDOWPOS_UNDEFINED,
    320,
    240,
    SDL2::WINDOW_RESIZABLE,
) or die "Error creating SDL window: " . SDL2::GetError;

my @titles = (
    't',
    'thi',
    'this w',
    'this win',
    'this windo',
    "this window's",
    "this window's ti",
    "this dinwos's title",
    "chis window's title is",
    "chih window's title is ",
    "chih wandnw's title is ",
    "c  h wandnw'g title is ",
    "c  h  a  nw'g titln is ",
    "c  h  a  n  g  i  n ig!",
    '',
    'c  h  a  n  g  i  n  g!',
    '',
    'c  h  a  n  g  i  n  g!',
    'c  h  a  n  g  i  n  g!',
);

my $event = SDL2::Event->new;

MAIN: while (1) {
    state $t = 0;
    state $i = 0;

    while ( SDL2::PollEvent($event) ) {
        last MAIN if $event->type == SDL2::QUIT;
    }

    unless ( ++$t % 9 ) {
        SDL2::SetWindowTitle( $window, $titles[$i] );
        $i = 0 if ++$i > $#titles;
    }

    SDL2::Delay(10);
}

SDL2::DestroyWindow($window);
SDL2::Quit;
