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
        if( renderer == NULL )
            warn( "ERROR making renderer: %s", SDL_GetError() );
        RETVAL = renderer;
	OUTPUT:
		RETVAL

int
renderer_clear ( renderer )
    SDL_Renderer* renderer
    CODE:
        RETVAL = SDL_RenderClear( renderer );
    OUTPUT:
        RETVAL

int
renderer_draw_rect (renderer, rect)
    SDL_Renderer* renderer
    SDL_Rect* rect
    CODE:
        RETVAL = SDL_RenderDrawRect(renderer, rect);
    OUTPUT:
        RETVAL


int
renderer_fill_rect (renderer, rect)
    SDL_Renderer* renderer
    SDL_Rect* rect
    CODE:
        RETVAL = SDL_RenderFillRect(renderer, rect);
    OUTPUT:
        RETVAL


void
renderer_present ( renderer )
    SDL_Renderer* renderer
    CODE:
        SDL_RenderPresent( renderer );

int
renderer_set_draw_color (renderer, r, g, b, a)
    SDL_Renderer* renderer
    Uint8 r
    Uint8 g
    Uint8 b
    Uint8 a
    CODE:
        warn("Color: %d %d %d %d", r, g, b, a);
        RETVAL = SDL_SetRenderDrawColor(renderer, r, g, b, a);
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
