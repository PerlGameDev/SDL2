package SDL2::Mixer;

use strict;
use warnings;

use SDL2::Raw;
use FFI::CheckLib;
use FFI::Platypus 1.00;
use FFI::C;
use Ref::Util;

BEGIN {
    require constant;

    my %enums = (
        InitFlags => {
            INIT_FLAC          => 0x01,
            INIT_MOD           => 0x02,
            INIT_MP3           => 0x08,
            INIT_OGG           => 0x10,
            INIT_MID           => 0x20,
            INIT_OPUS          => 0x40,
        },
        Fading => {
            NO_FADING          => 0,
            FADING_OUT         => 1,
            FADING_IN          => 2,
        },
        MusicType => {
            MUS_NONE           =>  0,
            MUS_CMD            =>  1,
            MUS_WAV            =>  2,
            MUS_MOD            =>  3,
            MUS_MID            =>  4,
            MUS_OGG            =>  5,
            MUS_MP3            =>  6,
            MUS_MP3_MAD_UNUSED =>  7,
            MUS_FLAC           =>  8,
            MUS_MODPLUG_UNUSED =>  9,
            MUS_OPUS           => 10,
        },
    );

    while ( my ( $name, $values ) = each %enums ) {
        constant->import($values);

        my $variable = __PACKAGE__ . '::' . $name;
        no strict 'refs';
        %{$variable} = ( %{$variable}, reverse %$values );
    }
}

use constant {
    CHANNEL_POST      => -2,
    DEFAULT_FREQUENCY => 44_100,
    DEFAULT_FORMAT    => SDL2::BYTEORDER == SDL2::LIL_ENDIAN ? SDL2::AUDIO_S16LSB : SDL2::AUDIO_S16MSB,
    DEFAULT_CHANNELS  => 2,
    MAX_VOLUME        => SDL2::MIX_MAXVOLUME,
};

my $ffi = FFI::Platypus->new( api => 1 );
$ffi->lib( find_lib_or_exit lib => 'SDL_mixer' );

FFI::C->ffi($ffi);
$ffi->mangler( sub { 'Mix_' . shift } );

package SDL2::Mixer::Chunk {
    FFI::C->struct( Mix_Chunk => [
        allocated => 'int',
        abuf      => 'opaque',
        alen      => 'uint32',
        volume    => 'uint8',
    ]);
}

$ffi->type( opaque                             => 'Mix_Music'      );
$ffi->type( int                                => 'Mix_MusicType'  );
$ffi->type( '(int, opaque, int, opaque)->void' => 'Mix_EffectFunc' );

## General

$ffi->attach( Init => ['uint32'] => 'int' );
$ffi->attach( Quit => [] => 'void' );
$ffi->attach( OpenAudio => ['int', 'uint16', 'int', 'int'] => 'int' );
$ffi->attach( CloseAudio => [] => 'void' );
$ffi->attach( QuerySpec => ['int*', 'uint16*', 'int*'] => 'int' );

sub SetError { goto &SDL2::SetError }
sub GetError { goto &SDL2::GetError }

## Samples

$ffi->attach( GetNumChunkDecoders => [                  ] => 'int'       );
$ffi->attach( GetChunkDecoder     => ['int'             ] => 'string'    );
$ffi->attach( LoadWAV_RW          => ['opaque', 'int'   ] => 'Mix_Chunk' );
$ffi->attach( QuickLoad_WAV       => ['uint8*'          ] => 'Mix_Chunk' );
$ffi->attach( QuickLoad_RAW       => ['uint8*'          ] => 'Mix_Chunk' );
$ffi->attach( VolumeChunk         => ['Mix_Chunk', 'int'] => 'Mix_Chunk' );
$ffi->attach( FreeChunk           => ['Mix_Chunk'       ] => 'void'      );
sub LoadWAV { LoadWAV_RW( SDL2::RWFromFile( shift, 'rb' ), 1 ) }

## Channels

$ffi->attach( AllocateChannels   => ['int'                                  ] => 'int'       );
$ffi->attach( Volume             => ['int', 'int'                           ] => 'int'       );
$ffi->attach( PlayChannelTimed   => ['int', 'Mix_Chunk', 'int', 'int'       ] => 'int'       );
$ffi->attach( FadeInChannelTimed => ['int', 'Mix_Chunk', 'int', 'int', 'int'] => 'int'       );
$ffi->attach( Pause              => ['int'                                  ] => 'void'      );
$ffi->attach( Resume             => ['int'                                  ] => 'void'      );
$ffi->attach( ExpireChannel      => ['int', 'int'                           ] => 'int'       );
$ffi->attach( FadeOutChannel     => ['int', 'int'                           ] => 'int'       );
$ffi->attach( Playing            => ['int'                                  ] => 'int'       );
$ffi->attach( Paused             => ['int'                                  ] => 'int'       );
$ffi->attach( FadingChannel      => ['int'                                  ] => 'int'       );
$ffi->attach( GetChunk           => ['int'                                  ] => 'Mix_Chunk' );
$ffi->attach( ChannelFinished    => ['(int)->void'                          ] => 'void' => sub { # Untested
    my ( $xsub, $closure ) = @_;
    $closure = $ffi->closure($closure) if Ref::Util::is_coderef $closure;
    $xsub->($closure);
});
sub PlayChannel   {   PlayChannelTimed( @_, -1 ) }
sub FadeInChannel { FadeInChannelTimed( @_, -1 ) }

## Groups

#TODO

## Music

$ffi->attach( GetNumMusicDecoders  => [                                   ] => 'int'           );
$ffi->attach( GetMusicDecoder      => ['int'                              ] => 'string'        );
$ffi->attach( LoadMUS              => ['string'                           ] => 'Mix_Music'     );
$ffi->attach( FreeMusic            => ['Mix_Music'                        ] => 'void'          );
$ffi->attach( PlayMusic            => ['Mix_Music', 'int'                 ] => 'int'           );
$ffi->attach( FadeInMusic          => ['Mix_Music', 'int', 'int'          ] => 'int'           );
$ffi->attach( FadeInMusicPos       => ['Mix_Music', 'int', 'int', 'double'] => 'int'           );
$ffi->attach( HookMusic            => ['(opaque, uint8)->void', 'opaque'  ] => 'void'          ); # Untested
$ffi->attach( VolumeMusic          => ['int'                              ] => 'int'           );
$ffi->attach( PauseMusic           => [                                   ] => 'void'          );
$ffi->attach( ResumeMusic          => [                                   ] => 'void'          );
$ffi->attach( RewindMusic          => [                                   ] => 'void'          );
$ffi->attach( SetMusicPosition     => ['double'                           ] => 'int'           );
$ffi->attach( SetMusicCMD          => ['string'                           ] => 'int'           );
$ffi->attach( HaltMusic            => [                                   ] => 'int'           );
$ffi->attach( FadeOutMusic         => ['int'                              ] => 'int'           );
$ffi->attach( HookMusicFinished    => ['()->void'                         ] => 'void'          ); # Untested
$ffi->attach( GetMusicType         => ['Mix_Music'                        ] => 'Mix_MusicType' );
$ffi->attach( PlayingMusic         => [                                   ] => 'int'           );
$ffi->attach( PausedMusic          => [                                   ] => 'int'           );
$ffi->attach( FadingMusic          => [                                   ] => 'int'           );
$ffi->attach( GetMusicHookData     => [                                   ] => 'opaque'        );

## Effects

$ffi->attach( RegisterEffect       => ['int', 'Mix_EffectFunc'                       ] => 'void' );
$ffi->attach( UnregisterEffect     => ['int', '(opaque, opaque, int)->void', 'opaque'] => 'void' );
$ffi->attach( UnregisterAllEffects => ['int'                                         ] => 'int'  );
$ffi->attach( SetPostMix           => ['(opaque, opaque, int)->void', 'opaque'       ] => 'void' );
$ffi->attach( SetPanning           => ['int', 'uint8', 'uint8'                       ] => 'int'  );
$ffi->attach( SetDistance          => ['int', 'uint8'                                ] => 'int'  );
$ffi->attach( SetPosition          => ['int', 'sint16', 'uint8'                      ] => 'int'  );
$ffi->attach( SetReverseStereo     => ['int', 'int'                                  ] => 'int'  );

1;
