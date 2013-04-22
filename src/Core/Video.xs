#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <stdio.h>

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL2/SDL.h>



MODULE = SDL2::Video	PACKAGE = SDL2::Video   PREFIX = video_

const char *
get_current_video_driver ( )
    CODE:
        RETVAL = SDL_GetCurrentVideoDriver();
    OUTPUT:
        RETVAL


int
get_num_video_drivers () 
    CODE:
        RETVAL = SDL_GetNumVideoDrivers();
    OUTPUT:
        RETVAL


const char *
get_video_driver ( index )
    int index
    CODE:
        RETVAL = SDL_GetVideoDriver( index );
    OUTPUT:
        RETVAL


