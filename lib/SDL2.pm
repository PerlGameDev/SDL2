package SDL2;
use strict;
use warnings;
use SDL2pp;

sub init {
    return SDL2pp::init(@_);
}

sub quit {
    return SDL2pp::quit(@_);
}
1;
