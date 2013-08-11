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

int
constant_SDL_PIXELFORMAT_UNKNOWN ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_UNKNOWN;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_INDEX1LSB ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_INDEX1LSB;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_INDEX1MSB ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_INDEX1MSB;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_INDEX4LSB ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_INDEX4LSB;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_INDEX4MSB ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_INDEX4MSB;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_INDEX8 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_INDEX8;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_RGB332 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_RGB332;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_RGB444 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_RGB444;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_RGB555 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_RGB555;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_BGR555 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_BGR555;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_ARGB4444 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_ARGB4444;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_RGBA4444 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_RGBA4444;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_ABGR4444 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_ABGR4444;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_BGRA4444 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_BGRA4444;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_ARGB1555 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_ARGB1555;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_RGBA5551 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_RGBA5551;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_ABGR1555 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_ABGR1555;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_BGRA5551 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_BGRA5551;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_RGB565 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_RGB565;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_BGR565 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_BGR565;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_RGB24 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_RGB24;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_BGR24 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_BGR24;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_RGB888 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_RGB888;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_RGBX8888 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_RGBX8888;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_BGR888 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_BGR888;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_BGRX8888 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_BGRX8888;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_ARGB8888 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_ARGB8888;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_RGBA8888 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_RGBA8888;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_ABGR8888 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_ABGR8888;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_BGRA8888 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_BGRA8888;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_ARGB2101010 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_ARGB2101010;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_YV12 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_YV12;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_IYUV ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_IYUV;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_YUY2 ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_YUY2;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_UYVY ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_UYVY;
    OUTPUT:
        RETVAL

int
constant_SDL_PIXELFORMAT_YVYU ()
    CODE:
        RETVAL = SDL_PIXELFORMAT_YVYU;
    OUTPUT:
        RETVAL
