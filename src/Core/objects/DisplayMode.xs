#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"
#include <stdio.h>

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL2/SDL.h>

MODULE = SDL2::DisplayMode 	PACKAGE = SDL2::DisplayMode    PREFIX = displaymode_

=for documentation

SDL_DisplayMode -- Defines an SDL DisplayMode
=cut

SDL_DisplayMode *
displaymode_new (CLASS, w, h, refresh_rate)
    char* CLASS
    int w
    int h
    int refresh_rate
	CODE:
        SDL_DisplayMode* displaymode = safemalloc( sizeof( SDL_DisplayMode) );
        displaymode->w = w;
        displaymode->h = h;
        displaymode->refresh_rate = refresh_rate;
        displaymode->driverdata = 0;
        RETVAL = displaymode;
	OUTPUT:
		RETVAL


int 
displaymode_w (dm, ...)
    SDL_DisplayMode *dm
    CODE:
        if (items > 1) dm->w = SvIV(ST(1));
        RETVAL = dm->w;
    OUTPUT:
        RETVAL

int 
displaymode_h (dm, ...)
    SDL_DisplayMode *dm
    CODE:
        if (items > 1) dm->h = SvIV(ST(1));
        RETVAL = dm->h;
    OUTPUT:
        RETVAL

int 
displaymode_refresh_rate (dm, ...)
    SDL_DisplayMode *dm
    CODE:
        if (items > 1) dm->refresh_rate = SvIV(ST(1));
        RETVAL = dm->refresh_rate;
    OUTPUT:
        RETVAL


void
displaymode_DESTROY(bag)
	SV *bag
	CODE:
        objDESTROY( bag, safefree );

