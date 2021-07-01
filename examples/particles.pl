#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use experimental 'signatures';

use constant {
    PARTICLES => 1000,
    WIDTH     => 800,
    HEIGHT    => 600,
};

use SDL2::Raw;
use Time::HiRes 'time';
use POSIX 'floor';

die "Could not initialise SDL2: " . SDL2::GetError
    if SDL2::Init( SDL2::INIT_VIDEO );

my $window = SDL2::CreateWindow(
    'Particle System!',
    SDL2::WINDOWPOS_CENTERED,
    SDL2::WINDOWPOS_CENTERED,
    WIDTH,
    HEIGHT,
    SDL2::WINDOW_SHOWN,
) or die "Error creating SDL window: " . SDL2::GetError;

my $renderer = SDL2::CreateRenderer(
    $window,
    -1,
    SDL2::RENDERER_ACCELERATED,
) or die "Error creating SDL renderer: " . SDL2::GetError;

my $info = SDL2::RendererInfo->new;
SDL2::GetRendererInfo( $renderer, $info )
    and die 'Could not get renderer info: ' . SDL2::GetError;

debug( $info => qw(
    flags
    max_texture_height
    max_texture_width
    name
    num_texture_formats
    texture_formats
));

my @points;
my @pos  = (0) x ( PARTICLES * 2 );
my @vel  = (0) x ( PARTICLES * 2 );
my @life = (0) x   PARTICLES;

my @times;
my $df = 0;
MAIN: while (1) {
    my $start = time;
    my $event = SDL2::Event->new;

    while ( SDL2::PollEvent($event) ) {
        last MAIN if $event->type == SDL2::QUIT;
    }

    update($df);
    render();

    push @times, $df = time - $start;
}

@times = sort @times;

my @timings = (
    $times[ int @times              /  50 ],
    $times[ int @times              /   4 ],
    $times[ int @times              /   2 ],
    $times[ int @times * 3          /   4 ],
    $times[     @times - int @times / 100 ],
);

say 'frames per second:';
say join ' ', map { sprintf '%3.4f', 1 / $_ } @timings;
say 'timings:';
say join ' ', map { sprintf '%3.4f',     $_ } @timings;
print "\n";

# Helpers

sub update ($df) {
    my ( $x, $y ) = ( 0, 1 );

    my $point = 0;

    for my $i ( 0 .. PARTICLES - 1 ) {
        my $will_draw;

        if ( $life[$i] <= 0 ) {
            if ( rand() < $df ) {
                $life[$i] = rand() * 10;

                @vel[$x] = ( rand() - 0.5 ) * 10;
                @vel[$y] = ( rand() - 2   ) * 10;

                @pos[$x]  =     WIDTH  / 20;
                @pos[$y]  = 3 * HEIGHT / 50;

                $will_draw = 1;
            }
        }

        else {
            $vel[$y] *= -0.6 if $pos[$y] > HEIGHT / 10 && $vel[$y] > 0;

            $vel[$y] += 9.81 * $df;

            $pos[$x] += $vel[$x] * $df;
            $pos[$y] += $vel[$y] * $df;

            $life[$i] -= $df;

            $will_draw = 1;
        }

        if ($will_draw) {
            $points[$point++] = floor $pos[$x] * 10;
            $points[$point++] = floor $pos[$y] * 10;
        }

        $y = ( $x += 2 ) + 1;
    }
}

sub render {
    SDL2::SetRenderDrawColor( $renderer, 0x0, 0x0, 0x0, 0xff );
    SDL2::RenderClear($renderer);

    SDL2::SetRenderDrawColor( $renderer, 0xff, 0xff, 0xff, 0x7f );
    SDL2::RenderDrawPoints( $renderer, \@points, int @points / 2 );

    SDL2::RenderPresent($renderer);
}

SDL2::DestroyRenderer($renderer);
SDL2::DestroyWindow($window);

# Helpers

sub debug {
    use Data::Dumper;
    local $Data::Dumper::Terse    = 1;
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Sortkeys = 1;
    my $x = shift;
    say ref($x) . ': ' . Dumper({ map { $_ => $x->$_ } @_ });
}
