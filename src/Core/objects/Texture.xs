#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL2/SDL.h>

MODULE = SDL2::Texture 	PACKAGE = SDL2::Texture    PREFIX = texture_


SDL_Texture *
texture_new (CLASS, renderer, format, access, w, h)
    	char* CLASS
        SDL_Renderer* renderer    
    	Uint32 format
        int access
        int w
        int h
	CODE:
        RETVAL = SDL_CreateTexture(renderer, format, access, w, h);
	OUTPUT:
		RETVAL


void
texture_DESTROY(bag)
	SV *bag
	CODE:
		objDESTROY(bag, SDL_DestroyTexture);
