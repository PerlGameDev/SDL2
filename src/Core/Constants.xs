#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL2/SDL.h>

MODULE = SDL2::Constants 	PACKAGE = SDL2::Constants    PREFIX = constant_


int
constant_SDL_TEXTUREACCESS_STATIC ( )
	CODE:
		RETVAL = SDL_TEXTUREACCESS_STATIC;
	OUTPUT:
		RETVAL

int
constant_SDL_TEXTUREACCESS_STREAMING ( )
	CODE:
		RETVAL = SDL_TEXTUREACCESS_STREAMING;
	OUTPUT:
		RETVAL


