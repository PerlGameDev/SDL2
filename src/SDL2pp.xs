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

IV
get_handle ()
	CODE:
		RETVAL = 0;
	OUTPUT:
		RETVAL


