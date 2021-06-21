#!/usr/bin/env perl

use Test2::V0;
use SDL2::Raw;
use version;

SDL2::Init(0) and die 'Could not initialise SDL2: ' . SDL2::GetError;

my $window = SDL2::CreateWindow('', 0, 0, 0, 0, SDL2::WINDOW_HIDDEN)
    or die "Error creating SDL window: " . SDL2::GetError;

END {
    SDL2::DestroyWindow($window);
    SDL2::Quit;
}

my $info = SDL2::SysWMinfo->new;
SDL2::GetVersion( $info->version );

ok SDL2::GetWindowWMInfo( $window, $info ), 'GetWindowWMInfo';

my $v = $info->version;
my $version = eval {
    version->parse( sprintf '%s.%s.%s', $v->major, $v->minor, $v->patch );
} // $@;

like $version, qr/^2\.\d+\.\d+$/a,
    "Running on version $version";

my $system = '';
for ( $info->subsystem ) {
    $system = 'an unknown system!'    if $_ == SDL2::SYSWM_UNKNOWN;
    $system = 'Microsoft Windows(TM)' if $_ == SDL2::SYSWM_WINDOWS;
    $system = 'X Window System'       if $_ == SDL2::SYSWM_X11;
    $system = 'DirectFB'              if $_ == SDL2::SYSWM_DIRECTFB;
    $system = 'Apple OS X'            if $_ == SDL2::SYSWM_COCOA;
    $system = 'UIKit'                 if $_ == SDL2::SYSWM_UIKIT;
}

ok $system, "Running on $system";

done_testing;
