#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say state );

use SDL2::Raw;

say 'This demo should print some system information';

SDL2::Init(0) and die 'Could not initialise SDL2: ' . SDL2::GetError;

my $window = SDL2::CreateWindow('', 0, 0, 0, 0, SDL2::WINDOW_HIDDEN)
    or die "Error creating SDL window: " . SDL2::GetError;

my $info = SDL2::SysWMinfo->new;
SDL2::GetVersion( $info->version );

if ( SDL2::GetWindowWMInfo( $window, $info ) ) {
    my $v = $info->version;
    printf 'This program is running SDL version %s.%s.%s on ',
        $v->major, $v->minor, $v->patch;

    for ( $info->subsystem ) {
        print 'an unknown system!'    if $_ == SDL2::SYSWM_UNKNOWN;
        print 'Microsoft Windows(TM)' if $_ == SDL2::SYSWM_WINDOWS;
        print 'X Window System'       if $_ == SDL2::SYSWM_X11;
        print 'DirectFB'              if $_ == SDL2::SYSWM_DIRECTFB;
        print 'Apple OS X'            if $_ == SDL2::SYSWM_COCOA;
        print 'UIKit'                 if $_ == SDL2::SYSWM_UIKIT;
    }

    print "\n";
}
else {
    print "Couldn't get window information: " . SDL2::GetError . "\n";
}

SDL2::DestroyWindow($window);
SDL2::Quit;
