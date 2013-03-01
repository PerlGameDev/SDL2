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

MODULE = SDL2::Renderer 	PACKAGE = SDL2::Renderer    PREFIX = renderer_

=for documentation

SDL_Renderer -- Defines an SDL Renderer
=cut

SDL_Renderer *
renderer_new (CLASS, window, index, flags)
    char* CLASS
	SDL_Window* window
	int index
	Uint32 flags
	CODE:
        SDL_Renderer* renderer = SDL_CreateRenderer(window, index, flags);
        //warn( "Made renderer %p", renderer);
        RETVAL = renderer;
	OUTPUT:
		RETVAL

void
renderer_DESTROY(bag)
	SV *bag
	CODE:
        void* obj = bag2obj( bag );
        SDL_Renderer* renderer = (SDL_Renderer*)obj;
        //warn( "Destroying bag: %p obj: %p renderer %p", bag, obj, renderer );
		SDL_DestroyRenderer( renderer );
        //warn( "Destroyed"); 
