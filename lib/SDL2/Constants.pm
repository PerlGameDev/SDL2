package SDL2::Constants;
use warnings;
use base 'Exporter';
use Config;

our @EXPORT_OK   = ();

our %EXPORT_TAGS = (
    'SDL2/init' => [
        qw (
    SDL_INIT_TIMER           
    SDL_INIT_AUDIO           
    SDL_INIT_VIDEO           
    SDL_INIT_JOYSTICK        
    SDL_INIT_HAPTIC          
    SDL_INIT_GAMECONTROLLER  
    SDL_INIT_NOPARACHUTE  
    SDL_INIT_EVERYTHING
       
        )
    ]
);

#From https://github.com/PerlGameDev/SDL/blob/master/lib/SDL/Constants.pm#L609

my %seen;


foreach my $package ( keys %EXPORT_TAGS ) {
    my $super_package = $package;
    $super_package =~ s/\/.*$//;
    push( @{ $EXPORT_TAGS{$super_package} }, @{ $EXPORT_TAGS{$package} } )
        if $super_package ne $package;
    push( @EXPORT_OK, grep { !$seen{$_}++ } @{ $EXPORT_TAGS{$package} } );
}

use constant {
    SDL_INIT_TIMER           => 0x00000001,
    SDL_INIT_AUDIO           => 0x00000010,
    SDL_INIT_VIDEO           => 0x00000020,
    SDL_INIT_JOYSTICK        => 0x00000200,
    SDL_INIT_HAPTIC          => 0x00001000,
    SDL_INIT_GAMECONTROLLER  => 0x00002000,
    SDL_INIT_NOPARACHUTE     => 0x00100000,
    SDL_INIT_EVERYTHING      => 0x0000FFFF
}; # SDL/init


1;
