#!/usr/bin/env perl

use SDL2::Raw;
use SDL2::Raw::Mixer;
use Getopt::Long;

use feature qw( say state );

my $AUDIO_FORMAT = SDL2::Mixer::DEFAULT_FORMAT;

GetOptions(
    'interactive|i' => \( my $INTERACTIVE    = 1 ),
    'loop|l'        => \( my $LOOPING        = 1 ),
    '8'             => sub { $AUDIO_FORMAT   = SDL2::AUDIO_U8 },
    'f32'           => sub { $AUDIO_FORMAT   = SDL2::AUDIO_F32 },
    'rate|r=i'      => \( my $AUDIO_RATE     = SDL2::Mixer::DEFAULT_FREQUENCY ),
    'channels|c=i'  => \( my $AUDIO_CHANNELS = SDL2::Mixer::DEFAULT_CHANNELS ),
    'buffers|b=i'   => \( my $AUDIO_BUFFERS  = 4096 ),
    'olumev=i'      => \( my $AUDIO_VOLUME   = SDL2::Mixer::MAX_VOLUME ),
    'rwops'         => \( my $RWOPS          = 0 ),
    'mono|m'        => sub { $AUDIO_CHANNELS = 1 },
);

SDL2::Init(SDL2::INIT_AUDIO)
    and die 'Could not initialise SDL2: ' . SDL2::GetError;

# TODO: INT  handler
# TODO: TERM handler

END { SDL2::Quit }

SDL2::Mixer::OpenAudio(
    $AUDIO_RATE,
    $AUDIO_FORMAT,
    $AUDIO_CHANNELS,
    $AUDIO_BUFFERS,
) and die 'Could not open audio: ' . SDL2::GetError;

SDL2::Mixer::QuerySpec( \$AUDIO_RATE, \$AUDIO_FORMAT, \$AUDIO_CHANNELS);
say sprintf 'Opened audio at %d Hz %d bit%s %s %d bytes audio buffer',
    $AUDIO_RATE,
    ( $AUDIO_FORMAT & 0xFF ),
    $AUDIO_FORMAT & SDL2::AUDIO_MASK_DATATYPE ? ' (float)' : '',
    $AUDIO_CHANNELS > 2 ? 'surround' : $AUDIO_CHANNELS > 1 ? 'stereo' : 'mono',
    $AUDIO_BUFFERS;

SDL2::Mixer::VolumeMusic($AUDIO_VOLUME);

SDL2::Mixer::SetMusicCMD( $ENV{MUSIC_CMD} );

for my $file (@ARGV) {
    my $music = $RWOPS
        ? SDL2::Mixer::LoadMUS_RW( SDL2::RWFromFile( $file, 'rb' ), 1 )
        : SDL2::Mixer::LoadMUS($file);

    die "Could not load $file: " . SDL2::GetError unless $music;

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

    say "Detected music type: $type";
}
