package SDL2::Mixer;

use strict;
use warnings;

use SDL2::Raw;
use FFI::CheckLib;
use FFI::Platypus 1.00;
use Ref::Util;

use constant {
    INIT_JPG  => 0x1,
    INIT_PNG  => 0x2,
    INIT_TIF  => 0x4,
    INIT_WEBP => 0x8,

    NO_FADING  => 0,
    FADING_OUT => 1,
    FADING_IN  => 2,
};

my $ffi = FFI::Platypus->new( api => 1 );
$ffi->lib( find_lib_or_exit lib => 'SDL_mixer' );

$ffi->mangler( sub { 'Mix_' . shift } );
$ffi->type( opaque => 'Mix_Chunk' );

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
sub LoadWav { LoadWAV_RW( SDL2::RWFromFile( shift, 'rb' ), 1 ) }

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
$ffi->attach( ChannelFinished    => ['(int)->void'                          ] => 'void' => sub {
    my ( $xsub, $closure ) = @_;
    $closure = $ffi->closure($closure) if Ref::Util::is_subref $closure;
    $xsub->($closure);
});
sub PlayChannel   {   PlayChannelTimed( @_, -1 ) }
sub FadeInChannel { FadeInChannelTimed( @_, -1 ) }

## Groups

1;
