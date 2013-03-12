#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <stdio.h>

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL2/SDL.h>



MODULE = SDL2pp	PACKAGE = SDL2pp
PROTOTYPES : DISABLE

int
init ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_Init(flags);
	OUTPUT:
		RETVAL

int
init_sub_system ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_InitSubSystem(flags);
	OUTPUT:
		RETVAL

void
delay ( time )
	Uint32 time
	CODE:
		SDL_Delay( time );


void
quit_sub_system ( flags )
	Uint32 flags
	CODE:
		SDL_QuitSubSystem(flags);

void
quit ()
	CODE:
		SDL_Quit();

int
was_init ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_WasInit(flags);
	OUTPUT:
		RETVAL

void
clear_hints ( )
    CODE:
        SDL_ClearHints();

char *
get_hint( name )
    char * name
    CODE:
        RETVAL = SDL_GetHint(name);
    OUTPUT:
        RETVAL


int
set_hint( name, value )
    char* name
    char* value
    CODE:
        SDL_bool result;
        result = SDL_SetHint( name, value );
        if( result == SDL_TRUE )
            RETVAL = 1;
        else
            RETVAL = 0;
    OUTPUT:
        RETVAL

int
set_hint_with_priority( name, value, priority)
    char* name
    char* value
    int priority
    CODE:
        SDL_bool result;
        SDL_HintPriority hp;
        hp = (SDL_HintPriority)priority;
        result = SDL_SetHintWithPriority( name, value, hp );
        if( result == SDL_TRUE )
            RETVAL = 1;
        else
            RETVAL = 0;
    OUTPUT:
        RETVAL


const char*
get_error ()
	CODE:
		RETVAL = SDL_GetError();
	OUTPUT:
		RETVAL


void
clear_error ()
    CODE:
        SDL_ClearError();


void
set_error (fmt)
    const char* fmt
    CODE: 
       SDL_SetError( fmt );


