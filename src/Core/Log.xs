#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL2/SDL.h>

MODULE = SDL2::Log 	PACKAGE = SDL2::Log    PREFIX = log_


void
log_set_all_priority ( pri )
	int pri
	CODE:
		SDL_LogSetAllPriority( pri );

void
log_set_priority ( cat, pri )
    int cat
	int pri
	CODE:
		SDL_LogSetPriority( cat, pri );

int
log_get_priority ( cat )
    int cat
	CODE:
		RETVAL = SDL_LogGetPriority( cat );
    OUTPUT:
        RETVAL


void
log_reset_priorities ( )
    CODE:
        SDL_LogResetPriorities();


void
log_log (fmt, ... )
    char * fmt
    CODE:
        SDL_Log( fmt, items ); 


void
log_verbose (fmt, ... )
    char * fmt
    CODE:
        SDL_LogVerbose( fmt, items ); 

void
log_debug (fmt, ... )
    char * fmt
    CODE:
        SDL_LogDebug( fmt, items ); 

void
log_info (fmt, ... )
    char * fmt
    CODE:
        SDL_LogInfo( fmt, items ); 

void
log_warn (fmt, ... )
    char * fmt
    CODE:
        SDL_LogWarn( fmt, items ); 

void
log_error (fmt, ... )
    char * fmt
    CODE:
        SDL_LogError( fmt, items ); 

void
log_message (fmt, pri, ... )
    char * fmt
    int pri
    CODE:
        SDL_LogMessage( fmt, pri, items ); 





