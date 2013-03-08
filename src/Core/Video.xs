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






