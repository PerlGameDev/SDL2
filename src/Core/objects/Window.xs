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

MODULE = SDL2::Window 	PACKAGE = SDL2::Window    PREFIX = window_

=for documentation

SDL_Window -- Defines an SDL window
=cut

SDL_Window *
window_new (CLASS, title, x, y, w, h, flags)
    char* CLASS
	char* title
	int x
	int y
	int w
	int h
	Uint32 flags
	CODE:
        SDL_Window* window = SDL_CreateWindow(title, x, y, w, h, flags);
        //warn( "Made window %p", window);
        RETVAL = window;
	OUTPUT:
		RETVAL

void
window_DESTROY(bag)
	SV *bag
	CODE:
        objDESTROY(bag, SDL_DestroyWindow);

