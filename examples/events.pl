#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say state );

use SDL2::Raw;
use SDL2::Raw::Image;

say 'This demo should capture all recognised SDL2 events';

die 'Could not initialise SDL2: ' . SDL2::GetError
    if SDL2::Init( SDL2::INIT_VIDEO | SDL2::INIT_GAMECONTROLLER );

my $window = SDL2::CreateWindow(
    'Event handling demo',
    SDL2::WINDOWPOS_CENTERED,
    SDL2::WINDOWPOS_CENTERED,
    320,
    240,
    SDL2::WINDOW_OPENGL | SDL2::WINDOW_RESIZABLE,
) or die 'Error creating SDL window: ' . SDL2::GetError;

my ( $done, $controller );
while ( !$done ) {
    handle_input();
    SDL2::Delay(10);
}

SDL2::DestroyWindow($window);

# Helpers

sub debug {
    use Data::Dumper;
    local $Data::Dumper::Terse    = 1;
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Sortkeys = 1;
    my $e = shift; say Dumper({ map { $_ => $e->$_ } @_ });
}

sub handle_input {
    state $event = SDL2::Event->new;

    while ( SDL2::PollEvent($event) ) {
        my $type = $event->type;

        if ( $type == SDL2::QUIT ) {
            $done = 1;
        }

        elsif ( $type == SDL2::KEYDOWN || $type == SDL2::KEYUP ) {
            say 'KEY ' . ( $type == SDL2::KEYDOWN ? 'DOWN' : 'UP' );
            my $e = $event->key;

            $done = 1 if $e->sym ==  SDL2::K_ESCAPE;

            debug $e => qw( type timestamp windowID state repeat scancode sym mod );
        }

        elsif ( $type == SDL2::WINDOWEVENT ) {
            my $e = $event->window;
            my $select = $e->event;

            if ( $select == SDL2::WINDOWEVENT_SHOWN ) {
                say 'WINDOW SHOWN';
                debug $e => qw( windowID );
            }

            elsif ( $select == SDL2::WINDOWEVENT_HIDDEN ) {
                say 'WINDOW HIDDEN';
                debug $e => qw( windowID );
            }

            elsif ( $select == SDL2::WINDOWEVENT_EXPOSED ) {
                say 'WINDOW EXPOSED';
                debug $e => qw( windowID );
            }

            elsif ( $select == SDL2::WINDOWEVENT_MOVED ) {
                say 'WINDOW MOVED';
                debug $e => qw( windowID data1 data2 );
            }

            elsif ( $select == SDL2::WINDOWEVENT_RESIZED ) {
                say 'WINDOW RESIZED';
                debug $e => qw( windowID data1 data2 );
            }

            elsif ( $select == SDL2::WINDOWEVENT_SIZE_CHANGED ) {
                say 'WINDOW SIZE CHANGED';
                debug $e => qw( windowID data1 data2 );
            }

            elsif ( $select == SDL2::WINDOWEVENT_MINIMIZED ) {
                say 'WINDOW MINIMIZED';
                debug $e => qw( windowID );
            }

            elsif ( $select == SDL2::WINDOWEVENT_MAXIMIZED ) {
                say 'WINDOW MAXIMIZED';
                debug $e => qw( windowID );
            }

            elsif ( $select == SDL2::WINDOWEVENT_RESTORED ) {
                say 'WINDOW RESTORED';
                debug $e => qw( windowID );
            }

            elsif ( $select == SDL2::WINDOWEVENT_ENTER ) {
                say 'WINDOW ENTER';
                debug $e => qw( windowID );
            }

            elsif ( $select == SDL2::WINDOWEVENT_LEAVE ) {
                say 'WINDOW LEAVE';
                debug $e => qw( windowID );
            }

            elsif ( $select == SDL2::WINDOWEVENT_FOCUS_GAINED ) {
                say 'WINDOW FOCUS GAINED';
                debug $e => qw( windowID );
            }

            elsif ( $select == SDL2::WINDOWEVENT_FOCUS_LOST ) {
                say 'WINDOW FOCUS LOST';
                debug $e => qw( windowID );
            }

            elsif ( $select == SDL2::WINDOWEVENT_CLOSE ) {
                say 'WINDOW CLOSE';
                debug $e => qw( windowID );
            }

            else {
                say 'WINDOW EVENT UNHANDLED';
                debug $e => qw( type windowID );
            }
        }

        elsif ( $type == SDL2::MOUSEMOTION ) {
            say 'MOUSE MOTION';
            debug $event->motion => qw( type timestamp which state x y xrel yrel );
        }

        elsif ( $type == SDL2::MOUSEWHEEL ) {
            say 'MOUSE WHEEL';
            debug $event->wheel => qw( type timestamp windowID which x y direction );
        }

        elsif ( $type == SDL2::DROPFILE || $type == SDL2::DROPTEXT ) {
            say sprintf '%s DROPPED', $type == SDL2::DROPFILE ? 'FILE' : 'TEXT';
            debug $event->drop => qw( type timestamp file );
        }

        elsif ( $type == SDL2::MOUSEBUTTONDOWN || $type == SDL2::MOUSEBUTTONUP ) {
            say 'MOUSE ' . ( $type == SDL2::MOUSEBUTTONDOWN ? 'DOWN' : 'UP' );
            debug $event->button => qw( type timestamp windowID which button state clicks padding1 x y );
        }

        elsif ( $type == SDL2::TEXTEDITING ) {
            say 'TEXT EDITED';
            debug $event->edit => qw( type timestamp windowID text start length );
        }

        elsif ( $type == SDL2::TEXTINPUT ) {
            say 'TEXT INPUT';
            debug $event->text => qw( type timestamp windowID text );
        }

        elsif ( $type == SDL2::CONTROLLERDEVICEADDED ) {
            say 'CONTROLLER ADDED';
            my $e = $event->cdevice;
            my $index = $e->which;
            if ( SDL2::IsGameController($index) ) {
                if ( my $pad = SDL2::GameControllerOpen($index) ) {
                    my $id = SDL2::JoystickInstanceID(
                        SDL2::GameControllerGetJoystick($pad) );

                    say sprintf 'Opened controller %i (%s)', $id,
                        SDL2::GameControllerNameForIndex($index);

                    $controller = $pad;
                }
                else {
                    say 'Could not open game controller: ' . SDL2::GetError;
                }
            }
        }

        elsif ( $type == SDL2::CONTROLLERDEVICEREMOVED ) {
            say 'CONTROLLER REMOVED';
            my $e = $event->cdevice;
            my $index = $e->which;
            say "Controller $index has been removed";

            if ( $controller ) {
                SDL2::GameControllerClose($controller);
                undef $controller;
            }
            else {
                say 'Not a known controller!';
            }
        }

        elsif ( $type == SDL2::CONTROLLERAXISMOTION ) {
            say 'CONTROLLER AXIS MOVED';
            debug $event->caxis => qw( axis value );
        }

        elsif ( $type == SDL2::CONTROLLERDEVICEREMAPPED ) {
            say 'CONTROLLER DEVICE REMAPPED';
        }

        elsif ( $type == SDL2::CONTROLLERBUTTONDOWN || $type == SDL2::CONTROLLERBUTTONUP ) {
            say 'CONTROLLER BUTTON ' . ( $type == SDL2::CONTROLLERBUTTONDOWN ? 'PRESSED' : 'RELEASED' );
            debug $event->cbutton => qw( button state );
        }

        else {
            say 'UNHANDLED';
            debug $event => qw( type timestamp );
        }
    }

}
