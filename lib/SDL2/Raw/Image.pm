package SDL2::Image;

use strict;
use warnings;

use SDL2::Raw;
use FFI::CheckLib;
use FFI::Platypus 1.00;

BEGIN {
    require constant;

    my %enums = (
        InitFlags => {
            INIT_JPG  => 0x1,
            INIT_PNG  => 0x2,
            INIT_TIF  => 0x4,
            INIT_WEBP => 0x8,
        },
    );

    while ( my ( $name, $values ) = each %enums ) {
        constant->import($values);

        my $variable = __PACKAGE__ . '::' . $name;
        no strict 'refs';
        %{$variable} = ( %{$variable}, reverse %$values );
    }
}

my $ffi = FFI::Platypus->new( api => 1 );
$ffi->lib( find_lib_or_exit lib => 'SDL2_image' );

for my $name (qw( Renderer Texture )) {
    my $class = "SDL2::$name";
    $ffi->custom_type( "SDL_$name" => {
        native_type    => 'opaque',
        native_to_perl => sub {
            ! defined $_[0] ? undef : bless \$_[0], $class;
        },
    });
}

$ffi->custom_type( 'SDL_Surface' => {
    native_type    => 'opaque',
    native_to_perl => sub {
        # This is a bit sketch
        ! defined $_[0] ? undef : bless { ptr => $_[0] }, 'SDL2::Surface';
    },
});

$ffi->attach( [ 'SDL_GetError'    => 'GetError'    ] => [                        ] => 'string'      );
$ffi->attach( [ 'IMG_Init'        => 'Init'        ] => ['int'                   ] => 'int'         );
$ffi->attach( [ 'IMG_Load'        => 'Load'        ] => ['string'                ] => 'SDL_Surface' );
$ffi->attach( [ 'IMG_LoadTexture' => 'LoadTexture' ] => ['SDL_Renderer', 'string'] => 'SDL_Texture' );

1;
