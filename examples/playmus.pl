#!/usr/bin/env perl

use strict;
use warnings;

use SDL2::Raw;
use SDL2::Raw::Mixer;
use Getopt::Long;
use Syntax::Keyword::Defer;

my %OPT = (
    looping     => 1,
    interactive => 1,
    format      => SDL2::Mixer::DEFAULT_FORMAT,
    rate        => SDL2::Mixer::DEFAULT_FREQUENCY,
    channels    => SDL2::Mixer::DEFAULT_CHANNELS,
    buffers     => 4096,
    volume      => SDL2::Mixer::MAX_VOLUME,
);

GetOptions \%OPT, (
    'interactive|i',
    'loop|l',
    'rate|r=i',
    'channels|c=i',
    'buffers|b=i',
    'volume=i',
    'rwops',
    '8'      => sub { $OPT{format}   = SDL2::AUDIO_U8  },
    'f32'    => sub { $OPT{format}   = SDL2::AUDIO_F32 },
    'mono|m' => sub { $OPT{channels} = 1               },
);

SDL2::Init(SDL2::INIT_AUDIO)
    and die 'Could not initialise SDL2: ' . SDL2::GetError;

defer { SDL2::Quit }

my $NEXT_TRACK;
local $SIG{INT} = sub { $NEXT_TRACK++ };

SDL2::Mixer::OpenAudio( @OPT{qw( rate format channels buffers )} )
    and die 'Could not open audio: ' . SDL2::GetError;

defer { SDL2::Mixer::CloseAudio }

SDL2::Mixer::QuerySpec( \$OPT{rate}, \$OPT{format}, \$OPT{channels} );
print sprintf "Opened audio at %d Hz %d bit%s %s %d bytes audio buffer\n",
    $OPT{rate},
    $OPT{format} & SDL2::AUDIO_MASK_BITSIZE,
    $OPT{format} & SDL2::AUDIO_MASK_DATATYPE ? ' (float)' : '',
    $OPT{channels} > 2 ? 'surround' : $OPT{channels} > 1 ? 'stereo' : 'mono',
    $OPT{buffers};

SDL2::Mixer::VolumeMusic($OPT{volume});
SDL2::Mixer::SetMusicCMD($ENV{MUSIC_CMD});

defer {
    if ( SDL2::Mixer::PlayingMusic ) {
        SDL2::Mixer::FadeOutMusic(1500);
        SDL2::Delay(1500);
    }
}

for my $file (@ARGV) {
    $NEXT_TRACK = 0;

    my $music = $OPT{rwops}
        ? SDL2::Mixer::LoadMUS_RW( SDL2::RWFromFile( $file, 'rb' ), 1 )
        : SDL2::Mixer::LoadMUS($file);

    die "Could not load $file: " . SDL2::GetError unless $music;

    defer { SDL2::Mixer::FreeMusic($music) }

    my $type = '';
    for ( SDL2::Mixer::GetMusicType($music) ) {
        $type
            = $_ == SDL2::Mixer::MUS_CMD            ? 'CMD'
            : $_ == SDL2::Mixer::MUS_WAV            ? 'WAV'
            : $_ == SDL2::Mixer::MUS_MOD            ? 'MOD'
            : $_ == SDL2::Mixer::MUS_MODPLUG_UNUSED ? 'MOD'
            : $_ == SDL2::Mixer::MUS_FLAC           ? 'FLAC'
            : $_ == SDL2::Mixer::MUS_MID            ? 'MIDI'
            : $_ == SDL2::Mixer::MUS_OGG            ? 'Ogg Vorbis'
            : $_ == SDL2::Mixer::MUS_MP3            ? 'MP3'
            : $_ == SDL2::Mixer::MUS_MP3_MAD_UNUSED ? 'MP3'
            : $_ == SDL2::Mixer::MUS_OPUS           ? 'OPUS'
            :                                         'NONE';
    }

    print "Detected music type: $type\n";

    print "Playing $file\n";
    SDL2::Mixer::FadeInMusic( $music, $OPT{looping}, 2000 );

    while ( !$NEXT_TRACK && SDL2::Mixer::PlayingMusic || SDL2::Mixer::PausedMusic ) {
        SDL2::Delay(100);
    }

    SDL2::Delay(500);

    last if $NEXT_TRACK > 1;
}
