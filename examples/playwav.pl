#!/usr/bin/env perl

use strict;
use warnings;

use SDL2::Raw;
use SDL2::Raw::Mixer;
use Getopt::Long;
use Syntax::Keyword::Defer;
use feature qw( state say );

use constant BUFFER => 4096;

my %tests = (
    decoders => 1,
    distance => 1,
    hook     => 1,
    panning  => 1,
    position => 1,
    versions => 1,
);

my $CHANNEL_DONE;
my %OPT = (
    loop         => 0,
    format       => SDL2::Mixer::DEFAULT_FORMAT,
    rate         => SDL2::Mixer::DEFAULT_FREQUENCY,
    channels     => SDL2::Mixer::DEFAULT_CHANNELS,
    flip_stereo  => 0,
    flip_samples => 0,
);

GetOptions \%OPT => (
    'help|?',
    'test=s@',
    'rate|r=i',
    'flip_stereo|flip-stereo|f',
    'flip_samples|flip-samples|F',
    'channels|c=i',
    '8'      => sub { $OPT{format}   = SDL2::AUDIO_U8  },
    'f32'    => sub { $OPT{format}   = SDL2::AUDIO_F32 },
    'mono|m' => sub { $OPT{channels} =  1              },
    'loop|l' => sub { $OPT{loop}     = -1              },
);

my $filename = shift;

if ( my @bad = grep { !$tests{ lc $_ } } @{ $OPT{test} } ) {
    say "Invalid test case selected: %s\n", join ',', @bad;
    $OPT{help} = 1;
}
else {
    $OPT{test} = { map { lc $_ => 1 } @{ $OPT{test} } };
}

print <<"USAGE" and exit if $OPT{help};
$0 - A test application for the SDL mixer library

Usage:

    $0 [OPTIONS] wavefile

Options:

    -8
        Load sound as unsigned, 8-bit samples

    --f32
        Load sound as 32-bit floating-point samples

    --rate NUMBER, -r NUMBER
        Set the sampling rate. Defaults to @{[ SDL2::Mixer::DEFAULT_FREQUENCY ]} Hz

    --channels NUMBER, -c NUMBER
        Set the number of channels. Defaults to @{[ SDL2::Mixer::DEFAULT_CHANNELS ]}

    --flip-stereo, -f
        Flip channels. Defaults to false.

    --flip-samples, -F
        Flip samples. Defaults to false.

    --mono, -m
        Play the sound through a single channel. Equivalent to --channels=1

    --loop, -l
        Loop sound

    --test TEST
        Enable a specific mixer test. Can be set multiple times.
        Possible (case-insensitive) values are
        * 'DECODERS'
        * 'DISTANCE'
        * 'HOOK'
        * 'PANNING'
        * 'POSITION'
        * 'VERSIONS'

    --help, -?
        Show this help message
USAGE

SDL2::Init(SDL2::INIT_AUDIO)
    and die 'Could not initialise SDL2: ' . SDL2::GetError;

defer { SDL2::Quit }

SDL2::Mixer::OpenAudio( @OPT{qw( rate format channels )}, BUFFER )
    and die 'Could not open audio: ' . SDL2::GetError;

defer { SDL2::Mixer::CloseAudio }

SDL2::Mixer::QuerySpec( \$OPT{rate}, \$OPT{format}, \$OPT{channels} );
say sprintf 'Opened audio at %d Hz %d bit%s %s %s',
    $OPT{rate},
    $OPT{format} & SDL2::AUDIO_MASK_BITSIZE,
    $OPT{format} & SDL2::AUDIO_MASK_DATATYPE ? ' (float)' : '',
    $OPT{channels} > 2 ? 'surround' : $OPT{channels} > 1 ? 'stereo' : 'mono',
    $OPT{loop} ? '(looping)' : '';

defer {
    if ( SDL2::Mixer::PlayingMusic ) {
        SDL2::Mixer::FadeOutMusic(1500);
        SDL2::Delay(1500);
    }
}

test_version() if $OPT{test}{versions};

test_decoders() if $OPT{test}{decoders};

my $wave = SDL2::Mixer::LoadWAV($filename)
    or die "Could not load $filename: " . SDL2::GetError;

defer { SDL2::Mixer::FreeChunk($wave) }

flip_sample($wave) if $OPT{flip_samples};

# FIXME: Hooks do not fire
SDL2::Mixer::ChannelFinished( sub { SDL2::Log('Channel finished') } ) if $OPT{test}{hook};

if ( ( !SDL2::Mixer::SetReverseStereo( SDL2::Mixer::CHANNEL_POST, 0+!!$OPT{flip_stereo} ) ) && $OPT{flip_stereo} ) {
    warn "Failed to set up reverse stereo effect!";
    warn 'Reason: ' . SDL2::GetError;
}

my $channel = SDL2::Mixer::PlayChannel( 0, $wave, $OPT{loop} );
die 'Could not play channel: ' . SDL2::GetError if $channel < 0;

while ( still_playing() ) {
    test_panning()  if $OPT{test}{panning};
    test_distance() if $OPT{test}{distance};
    test_position() if $OPT{test}{position};

    SDL2::Delay(1);
}

# Helpers

sub still_playing { $OPT{test}{hook} ? $CHANNEL_DONE : SDL2::Mixer::Playing(0) }

sub test_version {
    # TODO: can we report the SDL_mixer version?
    SDL2::GetVersion( my $v = SDL2::Version->new );
    say 'This program is running on SDL %d.%d.%d',
        $v->major, $v->minor, $v->patch;
}

sub test_decoders {
    for my $i ( 0 .. SDL2::Mixer::GetNumChunkDecoders() - 1 ) {
        printf " - chunk decoder: %s\n", SDL2::Mixer::GetChunkDecoder($i);
    }

    for my $i ( 0 .. SDL2::Mixer::GetNumMusicDecoders() - 1 ) {
        printf " - music decoder: %s\n", SDL2::Mixer::GetMusicDecoder($i);
    }
}

sub flip_sample {
    state $warn = do { say STDERR 'Sample flipping not yet implemented' };
}

sub test_panning {
    state $lvol = 128;
    state $rvol = 128;
    state $linc =  -1;
    state $rinc =   1;
    state $next =   0;
    state $ok   =   1;

    if ( $ok && SDL2::GetTicks() >= $next ) {
        $ok = SDL2::Mixer::SetPanning( 0, $lvol, $rvol )
            or warn sprintf 'SetPanning( 0, %s, %s ) failed: %s',
                $lvol, $rvol, SDL2::GetError;

        if ( $lvol == 255 || $lvol == 0 ) {
            say 'All the way to the left speaker' if $lvol == 255;
            $linc *= -1;
        }

        if ( $rvol == 255 || $rvol == 0 ) {
            say 'All the way to the right speaker' if $rvol == 255;
            $rinc *= -1;
        }

        $rvol += $rinc;
        $lvol += $linc;

        $next = SDL2::GetTicks() + 10;
    }

}

sub test_distance {
    state $distance = 1;
    state $dist_inc = 1;
    state $ok       = 1;
    state $next     = 0;

    if ( $ok && SDL2::GetTicks() >= $next ) {
        $ok = SDL2::Mixer::SetDistance( 0, $distance )
            or warn sprintf 'SetDistance( 0, %s ) failed: %s',
                $distance, SDL2::GetError;

        if ( $distance == 255 ) {
            say 'Distance at furthest point';
            $dist_inc *= -1;
        }
        elsif ( $distance == 0 ) {
            say 'Distance at nearest point';
            $dist_inc *= -1;
        }

        $distance += $dist_inc;
        $next = SDL2::GetTicks() + 15;
    }
}

sub test_position {
    state $distance  = 1;
    state $dist_inc  = 1;
    state $angle     = 0;
    state $angle_inc = 1;
    state $ok        = 1;
    state $next      = 0;

    if ( $ok && SDL2::GetTicks() >= $next ) {
        $ok = SDL2::Mixer::SetPosition( 0, $angle, $distance )
            or warn sprintf 'SetPosition( 0, %s, %s ) failed: %s',
                $angle, $distance, SDL2::GetError;

        if ( $angle == 0 ) {
            say 'Due north, now rotating clockwise';
            $angle_inc = 1;
        }
        elsif ( $angle == 360 ) {
            say 'Due north, now rotating counter-clockwise';
            $angle_inc = -1;
        }

        $distance += $dist_inc;

        if ( $distance < 0 ) {
            say 'Distance is very, very near. Stepping away by threes...';
            ( $distance, $dist_inc ) = ( 0, 3 );
        }
        elsif ( $distance > 255 ) {
            say 'Distance is very, very far. Stepping towards by threes...';
            ( $distance, $dist_inc ) = ( 255, -3 );
        }

        $angle += $angle_inc;
        $next = SDL2::GetTicks() + 30;
    }
}
