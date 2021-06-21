#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say state );

use SDL2::Raw;
use SDL2::Raw::Image;
use Getopt::Long;
use File::Share 'dist_file';

GetOptions(
    'scale=i' => \( my $scale =  3 ),
    'fps=i'   => \( my $fps   = 10 ),
);

die 'Could not initialise SDL2: ' . SDL2::GetError
    if SDL2::Init( SDL2::INIT_VIDEO );

my $window = SDL2::CreateWindow(
    'Sprite demo',
    SDL2::WINDOWPOS_CENTERED,
    SDL2::WINDOWPOS_CENTERED,
    16 * 8 * $scale,
    32 * $scale,
    SDL2::WINDOW_OPENGL | SDL2::WINDOW_RESIZABLE,
) or die 'Error creating SDL window: ' . SDL2::GetError;

my $renderer = SDL2::CreateRenderer( $window, -1, 0 )
    or die 'Error creating SDL renderer: ' . SDL2::GetError;

SDL2::Image::Init( SDL2::Image::INIT_PNG )
    or die 'Could not init PNG: ' . SDL2::GetError;

my $atlas = do {
    my $img = SDL2::Image::Load( dist_file 'SDL2-Raw', 'sheet.png' )
        or die 'Error loading image: ' . SDL2::GetError;

    SDL2::CreateTextureFromSurface($renderer, $img)
        or die 'Could not: ' . SDL2::GetError;
};

my $frame_length = int 1000 * 1 / $fps;
my @sprites = (
    Sprite->new( 128,   0, 16, 32 ), # elf_b
    Sprite->new( 128,  32, 16, 32 ), # elf_a
    Sprite->new( 128,  64, 16, 32 ), # knight_a
    Sprite->new( 128,  96, 16, 32 ), # knight_b
    Sprite->new( 128, 128, 16, 32 ), # wizard_a
    Sprite->new( 128, 160, 16, 32 ), # wizard_b
    Sprite->new( 128, 192, 16, 32 ), # lizard_a
    Sprite->new( 128, 224, 16, 32 ), # lizard_b
);

MAIN: while (1) {
    state $event = SDL2::Event->new;
    while ( SDL2::PollEvent($event) ) {
        last MAIN if $event->type == SDL2::QUIT;
    }

    SDL2::RenderClear($renderer);

    for my $i ( 0 .. $#sprites ) {
        my $sprite = $sprites[$i];
        $sprite->draw( $renderer, $i * $sprite->{w} * $scale, 0, $scale );
    }

    SDL2::RenderPresent($renderer);
    SDL2::Delay($frame_length);
}

SDL2::DestroyTexture($atlas);
SDL2::DestroyRenderer($renderer);
SDL2::DestroyWindow($window);

# Helpers

package Sprite {
    sub new {
        my ( $class, $x, $y, $w, $h ) = @_;

        bless {
            w      => $w,
            h      => $h,
            frame  => 0,
            frames => [
                map SDL2::Rect->new(
                    x => $x + $_ * $w,
                    y => $y,
                    w => $w,
                    h => $h,
                ), 0 .. 3
            ],
        } => $class;
    }

    sub draw {
        my ( $self, $renderer, $x, $y, $scale ) = @_;

        SDL2::RenderCopy(
            $renderer,
            $atlas,
            $self->{frames}[ $self->{frame} ],
            SDL2::Rect->new(
                x => $x,
                y => $y,
                w => $self->{w} * $scale,
                h => $self->{h} * $scale,
            ),
        ) and die 'Could not render texture: ' . SDL2::GetError;

        $self->{frame} = 0 if $self->{frame}++ >= $#{ $self->{frames} };
    }
}
