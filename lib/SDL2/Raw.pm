# ABSTRACT: FFI bindings for SDL2
package SDL2;

use strict;
use warnings;

use FFI::CheckLib ();
use FFI::Platypus 1.00;
use FFI::C;
use Ref::Util;

my $ffi;
BEGIN {
    $ffi = FFI::Platypus->new( api => 1 );
    $ffi->lib( FFI::CheckLib::find_lib_or_exit lib => 'SDL2' );
    FFI::C->ffi($ffi);
}

use Config;
use constant {
    K_SCANCODE_MASK => 1 << 30,
    BYTEORDER       => $Config{byteorder},
    BIG_ENDIAN      => 4321,
    LIL_ENDIAN      => 1234,
    MIX_MAXVOLUME   => 128,
    FALSE           => 0,
    TRUE            => 1,
    QUERY           => -1,
    IGNORE          => 0,
    DISABLE         => 0,
    ENABLE          => 1,
    RELEASED        => 0,
    PRESSED         => 1,
};

# Init flags
use constant {
    INIT_TIMER                => 0x000001,
    INIT_AUDIO                => 0x000010,
    INIT_VIDEO                => 0x000020,
    INIT_JOYSTICK             => 0x000200,
    INIT_HAPTIC               => 0x001000,
    INIT_GAMECONTROLLER       => 0x002000,
    INIT_EVENTS               => 0x004000,
    INIT_SENSOR               => 0x008000,
    INIT_NOPARACHUTE          => 0x100000,
};

use constant INIT_EVERYTHING => (
    INIT_TIMER    | INIT_AUDIO  | INIT_VIDEO          | INIT_EVENTS |
    INIT_JOYSTICK | INIT_HAPTIC | INIT_GAMECONTROLLER | INIT_SENSOR
);

# Window flags
use constant {
    WINDOWPOS_UNDEFINED       => 0x1FFF0000,
    WINDOWPOS_CENTERED        => 0x2FFF0000,
};

# Mouse buttons
use constant {
    BUTTON_LEFT   => 1,
    BUTTON_MIDDLE => 2,
    BUTTON_RIGHT  => 3,
    BUTTON_X1     => 4,
    BUTTON_X2     => 5,
};

# Audio flags
use constant {
    AUDIO_U8        => 0x0008, # Unsigned 8-bit samples
    AUDIO_S8        => 0x8008, # Signed 8-bit samples
    AUDIO_U16LSB    => 0x0010, # Unsigned 16-bit samples
    AUDIO_S16LSB    => 0x8010, # Signed 16-bit samples
    AUDIO_U16MSB    => 0x1010, # As above, but big-endian byte order
    AUDIO_S16MSB    => 0x9010, # As above, but big-endian byte order
    AUDIO_S32LSB    => 0x8020, # 32-bit integer samples
    AUDIO_S32MSB    => 0x9020, # As above, but big-endian byte order
    AUDIO_F32LSB    => 0x8120, # 32-bit floating point samples
    AUDIO_F32MSB    => 0x9120, # As above, but big-endian byte order

    AUDIO_MASK_BITSIZE  => 0xFF,
    AUDIO_MASK_DATATYPE => 1 <<  8,
    AUDIO_MASK_ENDIAN   => 1 << 12,
    AUDIO_MASK_SIGNED   => 1 << 15,
};

use constant {
    AUDIO_U16       => AUDIO_U16LSB,
    AUDIO_S16       => AUDIO_S16LSB,
    AUDIO_S32       => AUDIO_S32LSB,
    AUDIO_F32       => AUDIO_F32LSB,
};

sub enum {
    require enum::hash;
    require constant;

    my %enums = @_;
    while ( my ( $name, $values ) = each %enums ) {
        my $const = Ref::Util::is_hashref $values ? $values : { enum::hash::enum( @$values ) };

        constant->import($const);

        my $variable = __PACKAGE__ . '::' . $name;
        no strict 'refs';
        %{$variable} = ( %{$variable}, reverse %$const );
    }
}

sub pixel_format {
    my ( $type, $order, $layout, $bits, $bytes ) = @_;
    return ( 1       << 28 )
        |  ( $type   << 24 )
        |  ( $order  << 20 )
        |  ( $layout << 16 )
        |  ( $bits   <<  8 )
        |    $bytes;
}

BEGIN {
    enum(
        HintPriority => [qw(
            HINT_DEFAULT
            HINT_NORMAL
            HINT_OVERRIDE
        )],
        LogCategory  => [qw(
            LOG_CATEGORY_APPLICATION
            LOG_CATEGORY_ERROR
            LOG_CATEGORY_ASSERT
            LOG_CATEGORY_SYSTEM
            LOG_CATEGORY_AUDIO
            LOG_CATEGORY_VIDEO
            LOG_CATEGORY_RENDER
            LOG_CATEGORY_INPUT
            LOG_CATEGORY_TEST
            LOG_CATEGORY_RESERVED1
            LOG_CATEGORY_RESERVED2
            LOG_CATEGORY_RESERVED3
            LOG_CATEGORY_RESERVED4
            LOG_CATEGORY_RESERVED5
            LOG_CATEGORY_RESERVED6
            LOG_CATEGORY_RESERVED7
            LOG_CATEGORY_RESERVED8
            LOG_CATEGORY_RESERVED9
            LOG_CATEGORY_RESERVED10
            LOG_CATEGORY_CUSTOM
        )],
        LogPriority => [qw(
            LOG_PRIORITY_VERBOSE=1
            LOG_PRIORITY_DEBUG
            LOG_PRIORITY_INFO
            LOG_PRIORITY_WARN
            LOG_PRIORITY_ERROR
            LOG_PRIORITY_CRITICAL
            NUM_LOG_PRIORITIES
        )],
        WindowFlags => {
            WINDOW_FULLSCREEN         => 0x00000001,
            WINDOW_OPENGL             => 0x00000002,
            WINDOW_SHOWN              => 0x00000004,
            WINDOW_HIDDEN             => 0x00000008,
            WINDOW_BORDERLESS         => 0x00000010,
            WINDOW_RESIZABLE          => 0x00000020,
            WINDOW_MINIMIZED          => 0x00000040,
            WINDOW_MAXIMIZED          => 0x00000080,
            WINDOW_MOUSE_GRABBED      => 0x00000100,
            WINDOW_INPUT_FOCUS        => 0x00000200,
            WINDOW_MOUSE_FOCUS        => 0x00000400,
            WINDOW_FULLSCREEN_DESKTOP => 0x00001001,
            WINDOW_FOREIGN            => 0x00000800,
            WINDOW_ALLOW_HIGHDPI      => 0x00002000,
            WINDOW_MOUSE_CAPTURE      => 0x00004000,
            WINDOW_ALWAYS_ON_TOP      => 0x00008000,
            WINDOW_SKIP_TASKBAR       => 0x00010000,
            WINDOW_UTILITY            => 0x00020000,
            WINDOW_TOOLTIP            => 0x00040000,
            WINDOW_POPUP_MENU         => 0x00080000,
            WINDOW_KEYBOARD_GRABBED   => 0x00100000,
            WINDOW_VULKAN             => 0x10000000,
            WINDOW_METAL              => 0x20000000,
            WINDOW_INPUT_GRABBED      => 0x00000100,
        },
        WindowEventID => [qw(
            WINDOWEVENT_NONE
            WINDOWEVENT_SHOWN
            WINDOWEVENT_HIDDEN
            WINDOWEVENT_EXPOSED
            WINDOWEVENT_MOVED
            WINDOWEVENT_RESIZED
            WINDOWEVENT_SIZE_CHANGED
            WINDOWEVENT_MINIMIZED
            WINDOWEVENT_MAXIMIZED
            WINDOWEVENT_RESTORED
            WINDOWEVENT_ENTER
            WINDOWEVENT_LEAVE
            WINDOWEVENT_FOCUS_GAINED
            WINDOWEVENT_FOCUS_LOST
            WINDOWEVENT_CLOSE
            WINDOWEVENT_TAKE_FOCUS
            WINDOWEVENT_HIT_TEST
        )],
        DisplayEventID => [qw(
            DISPLAYEVENT_NONE
            DISPLAYEVENT_ORIENTATION
            DISPLAYEVENT_CONNECTED
            DISPLAYEVENT_DISCONNECTED
        )],
        DisplayOrientation => [qw(
            ORIENTATION_UNKNOWN
            ORIENTATION_LANDSCAPE
            ORIENTATION_LANDSCAPE_FLIPPED
            ORIENTATION_PORTRAIT
            ORIENTATION_PORTRAIT_FLIPPED
        )],
        GLattr => [qw(
            GL_RED_SIZE
            GL_GREEN_SIZE
            GL_BLUE_SIZE
            GL_ALPHA_SIZE
            GL_BUFFER_SIZE
            GL_DOUBLEBUFFER
            GL_DEPTH_SIZE
            GL_STENCIL_SIZE
            GL_ACCUM_RED_SIZE
            GL_ACCUM_GREEN_SIZE
            GL_ACCUM_BLUE_SIZE
            GL_ACCUM_ALPHA_SIZE
            GL_STEREO
            GL_MULTISAMPLEBUFFERS
            GL_MULTISAMPLESAMPLES
            GL_ACCELERATED_VISUAL
            GL_RETAINED_BACKING
            GL_CONTEXT_MAJOR_VERSION
            GL_CONTEXT_MINOR_VERSION
            GL_CONTEXT_EGL
            GL_CONTEXT_FLAGS
            GL_CONTEXT_PROFILE_MASK
            GL_SHARE_WITH_CURRENT_CONTEXT
            GL_FRAMEBUFFER_SRGB_CAPABLE
            GL_CONTEXT_RELEASE_BEHAVIOR
            GL_CONTEXT_RESET_NOTIFICATION
            GL_CONTEXT_NO_ERROR
        )],
        GLprofile => {
            GL_CONTEXT_PROFILE_CORE          => 0x0001,
            GL_CONTEXT_PROFILE_COMPATIBILITY => 0x0002,
            GL_CONTEXT_PROFILE_ES            => 0x0004,
        },
        GLcontextFlag => {
            GL_CONTEXT_DEBUG_FLAG              => 0x0001,
            GL_CONTEXT_FORWARD_COMPATIBLE_FLAG => 0x0002,
            GL_CONTEXT_ROBUST_ACCESS_FLAG      => 0x0004,
            GL_CONTEXT_RESET_ISOLATION_FLAG    => 0x0008,
        },
        GLcontextReleaseFlag => [qw(
            GL_CONTEXT_RELEASE_BEHAVIOR_NONE
            GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH
        )],
        GLContextResetNotification => [qw(
            GL_CONTEXT_RESET_NO_NOTIFICATION
            GL_CONTEXT_RESET_LOSE_CONTEXT
        )],
        RendererFlags => {
            RENDERER_SOFTWARE      => 0x00000001,
            RENDERER_ACCELERATED   => 0x00000002,
            RENDERER_PRESENTVSYNC  => 0x00000004,
            RENDERER_TARGETTEXTURE => 0x00000008,
        },
        ScaleMode => [qw(
            SCALEMODENEAREST
            SCALEMODELINEAR
            SCALEMODEBEST
        )],
        TextureAccess => [qw(
            TEXTUREACCESS_STATIC
            TEXTUREACCESS_STREAMING
            TEXTUREACCESS_TARGET
        )],
        TextureModulate => [qw(
            TEXTUREMODULATE_NONE
            TEXTUREMODULATE_COLOR
            TEXTUREMODULATE_ALPHA
        )],
        RendererFlip => [qw(
            FLIP_NONE
            FLIP_HORIZONTAL
            FLIP_VERTICAL
        )],
        BlendMode => {
            BLENDMODE_NONE    => 0x00000000,
            BLENDMODE_BLEND   => 0x00000001,
            BLENDMODE_ADD     => 0x00000002,
            BLENDMODE_MOD     => 0x00000004,
            BLENDMODE_MUL     => 0x00000008,
            BLENDMODE_INVALID => 0x7FFFFFFF,
        },
        BlendOperation => [qw(
            BLENDOPERATION_ADD
            BLENDOPERATION_SUBTRACT
            BLENDOPERATION_REV_SUBTRACT
            BLENDOPERATION_MINIMUM
            BLENDOPERATION_MAXIMUM
        )],
        BlendFactor => [qw(
            BLENDFACTOR_ZERO
            BLENDFACTOR_ONE
            BLENDFACTOR_SRC_COLOR
            BLENDFACTOR_ONE_MINUS_SRC_COLOR
            BLENDFACTOR_SRC_ALPHA
            BLENDFACTOR_ONE_MINUS_SRC_ALPHA
            BLENDFACTOR_DST_COLOR
            BLENDFACTOR_ONE_MINUS_DST_COLOR
            BLENDFACTOR_DST_ALPHA
            BLENDFACTOR_ONE_MINUS_DST_ALPHA
        )],
        PowerState => [qw(
            POWERSTATE_UNKNOWN
            POWERSTATE_ON_BATTERY
            POWERSTATE_NO_BATTERY
            POWERSTATE_CHARGING
            POWERSTATE_CHARGED
        )],
        EventAction => [qw(
            ADDEVENT
            PEEKEVENT
            GETEVENT
        )],
        SystemCursor => [qw(
            SYSTEM_CURSOR_ARROW
            SYSTEM_CURSOR_IBEAM
            SYSTEM_CURSOR_WAIT
            SYSTEM_CURSOR_CROSSHAIR
            SYSTEM_CURSOR_WAITARROW
            SYSTEM_CURSOR_SIZENWSE
            SYSTEM_CURSOR_SIZENESW
            SYSTEM_CURSOR_SIZEWE
            SYSTEM_CURSOR_SIZENS
            SYSTEM_CURSOR_SIZEALL
            SYSTEM_CURSOR_NO
            SYSTEM_CURSOR_HAND
            NUM_SYSTEM_CURSORS
        )],
        MouseWheelDirection => [qw(
            MOUSEWHEEL_NORMAL
            MOUSEWHEEL_FLIPPED
        )],
        PixelType => [qw(
            PIXELTYPE_UNKNOWN
            PIXELTYPE_INDEX1
            PIXELTYPE_INDEX4
            PIXELTYPE_INDEX8
            PIXELTYPE_PACKED8
            PIXELTYPE_PACKED16
            PIXELTYPE_PACKED32
            PIXELTYPE_ARRAYU8
            PIXELTYPE_ARRAYU16
            PIXELTYPE_ARRAYU32
            PIXELTYPE_ARRAYF16
            PIXELTYPE_ARRAYF32
        )],
        BitmapOrder => [qw(
            BITMAPORDER_NONE
            BITMAPORDER_4321
            BITMAPORDER_1234
        )],
        PackedOrder => [qw(
            PACKEDORDER_NONE
            PACKEDORDER_XRGB
            PACKEDORDER_RGBX
            PACKEDORDER_ARGB
            PACKEDORDER_RGBA
            PACKEDORDER_XBGR
            PACKEDORDER_BGRX
            PACKEDORDER_ABGR
            PACKEDORDER_BGRA
        )],
        ArrayOrder => [qw(
            ARRAYORDER_NONE
            ARRAYORDER_RGB
            ARRAYORDER_RGBA
            ARRAYORDER_ARGB
            ARRAYORDER_BGR
            ARRAYORDER_BGRA
            ARRAYORDER_ABGR
        )],
        PackedLayout => [qw(
            PACKEDLAYOUT_NONE
            PACKEDLAYOUT_332
            PACKEDLAYOUT_4444
            PACKEDLAYOUT_1555
            PACKEDLAYOUT_5551
            PACKEDLAYOUT_565
            PACKEDLAYOUT_8888
            PACKEDLAYOUT_2101010
            PACKEDLAYOUT_1010102
        )],
        ScanCode => [qw(
            SCANCODE_UNKNOWN

            SCANCODE_A=4
            SCANCODE_B
            SCANCODE_C
            SCANCODE_D
            SCANCODE_E
            SCANCODE_F
            SCANCODE_G
            SCANCODE_H
            SCANCODE_I
            SCANCODE_J
            SCANCODE_K
            SCANCODE_L
            SCANCODE_M
            SCANCODE_N
            SCANCODE_O
            SCANCODE_P
            SCANCODE_Q
            SCANCODE_R
            SCANCODE_S
            SCANCODE_T
            SCANCODE_U
            SCANCODE_V
            SCANCODE_W
            SCANCODE_X
            SCANCODE_Y
            SCANCODE_Z
            SCANCODE_1
            SCANCODE_2
            SCANCODE_3
            SCANCODE_4
            SCANCODE_5
            SCANCODE_6
            SCANCODE_7
            SCANCODE_8
            SCANCODE_9
            SCANCODE_0
            SCANCODE_RETURN
            SCANCODE_ESCAPE
            SCANCODE_BACKSPACE
            SCANCODE_TAB
            SCANCODE_SPACE
            SCANCODE_MINUS
            SCANCODE_EQUALS
            SCANCODE_LEFTBRACKET
            SCANCODE_RIGHTBRACKET
            SCANCODE_BACKSLASH
            SCANCODE_NONUSHASH
            SCANCODE_SEMICOLON
            SCANCODE_APOSTROPHE
            SCANCODE_GRAVE
            SCANCODE_COMMA
            SCANCODE_PERIOD
            SCANCODE_SLASH
            SCANCODE_CAPSLOCK
            SCANCODE_F1
            SCANCODE_F2
            SCANCODE_F3
            SCANCODE_F4
            SCANCODE_F5
            SCANCODE_F6
            SCANCODE_F7
            SCANCODE_F8
            SCANCODE_F9
            SCANCODE_F10
            SCANCODE_F11
            SCANCODE_F12
            SCANCODE_PRINTSCREEN
            SCANCODE_SCROLLLOCK
            SCANCODE_PAUSE
            SCANCODE_INSERT
            SCANCODE_HOME
            SCANCODE_PAGEUP
            SCANCODE_DELETE
            SCANCODE_END
            SCANCODE_PAGEDOWN
            SCANCODE_RIGHT
            SCANCODE_LEFT
            SCANCODE_DOWN
            SCANCODE_UP
            SCANCODE_NUMLOCKCLEAR
            SCANCODE_KP_DIVIDE
            SCANCODE_KP_MULTIPLY
            SCANCODE_KP_MINUS
            SCANCODE_KP_PLUS
            SCANCODE_KP_ENTER
            SCANCODE_KP_1
            SCANCODE_KP_2
            SCANCODE_KP_3
            SCANCODE_KP_4
            SCANCODE_KP_5
            SCANCODE_KP_6
            SCANCODE_KP_7
            SCANCODE_KP_8
            SCANCODE_KP_9
            SCANCODE_KP_0
            SCANCODE_KP_PERIOD
            SCANCODE_NONUSBACKSLASH
            SCANCODE_APPLICATION
            SCANCODE_POWER
            SCANCODE_KP_EQUALS
            SCANCODE_F13
            SCANCODE_F14
            SCANCODE_F15
            SCANCODE_F16
            SCANCODE_F17
            SCANCODE_F18
            SCANCODE_F19
            SCANCODE_F20
            SCANCODE_F21
            SCANCODE_F22
            SCANCODE_F23
            SCANCODE_F24
            SCANCODE_EXECUTE
            SCANCODE_HELP
            SCANCODE_MENU
            SCANCODE_SELECT
            SCANCODE_STOP
            SCANCODE_AGAIN
            SCANCODE_UNDO
            SCANCODE_CUT
            SCANCODE_COPY
            SCANCODE_PASTE
            SCANCODE_FIND
            SCANCODE_MUTE
            SCANCODE_VOLUMEUP
            SCANCODE_VOLUMEDOWN
            SCANCODE_KP_COMMA
            SCANCODE_KP_EQUALSAS400
            SCANCODE_INTERNATIONAL1
            SCANCODE_INTERNATIONAL2
            SCANCODE_INTERNATIONAL3
            SCANCODE_INTERNATIONAL4
            SCANCODE_INTERNATIONAL5
            SCANCODE_INTERNATIONAL6
            SCANCODE_INTERNATIONAL7
            SCANCODE_INTERNATIONAL8
            SCANCODE_INTERNATIONAL9
            SCANCODE_LANG1
            SCANCODE_LANG2
            SCANCODE_LANG3
            SCANCODE_LANG4
            SCANCODE_LANG5
            SCANCODE_LANG6
            SCANCODE_LANG7
            SCANCODE_LANG8
            SCANCODE_LANG9
            SCANCODE_ALTERASE
            SCANCODE_SYSREQ
            SCANCODE_CANCEL
            SCANCODE_CLEAR
            SCANCODE_PRIOR
            SCANCODE_RETURN2
            SCANCODE_SEPARATOR
            SCANCODE_OUT
            SCANCODE_OPER
            SCANCODE_CLEARAGAIN
            SCANCODE_CRSEL
            SCANCODE_EXSEL

            SCANCODE_KP_00=176
            SCANCODE_KP_000
            SCANCODE_THOUSANDSSEPARATOR
            SCANCODE_DECIMALSEPARATOR
            SCANCODE_CURRENCYUNIT
            SCANCODE_CURRENCYSUBUNIT
            SCANCODE_KP_LEFTPAREN
            SCANCODE_KP_RIGHTPAREN
            SCANCODE_KP_LEFTBRACE
            SCANCODE_KP_RIGHTBRACE
            SCANCODE_KP_TAB
            SCANCODE_KP_BACKSPACE
            SCANCODE_KP_A
            SCANCODE_KP_B
            SCANCODE_KP_C
            SCANCODE_KP_D
            SCANCODE_KP_E
            SCANCODE_KP_F
            SCANCODE_KP_XOR
            SCANCODE_KP_POWER
            SCANCODE_KP_PERCENT
            SCANCODE_KP_LESS
            SCANCODE_KP_GREATER
            SCANCODE_KP_AMPERSAND
            SCANCODE_KP_DBLAMPERSAND
            SCANCODE_KP_VERTICALBAR
            SCANCODE_KP_DBLVERTICALBAR
            SCANCODE_KP_COLON
            SCANCODE_KP_HASH
            SCANCODE_KP_SPACE
            SCANCODE_KP_AT
            SCANCODE_KP_EXCLAM
            SCANCODE_KP_MEMSTORE
            SCANCODE_KP_MEMRECALL
            SCANCODE_KP_MEMCLEAR
            SCANCODE_KP_MEMADD
            SCANCODE_KP_MEMSUBTRACT
            SCANCODE_KP_MEMMULTIPLY
            SCANCODE_KP_MEMDIVIDE
            SCANCODE_KP_PLUSMINUS
            SCANCODE_KP_CLEAR
            SCANCODE_KP_CLEARENTRY
            SCANCODE_KP_BINARY
            SCANCODE_KP_OCTAL
            SCANCODE_KP_DECIMAL
            SCANCODE_KP_HEXADECIMAL

            SCANCODE_LCTRL=224
            SCANCODE_LSHIFT
            SCANCODE_LALT
            SCANCODE_LGUI
            SCANCODE_RCTRL
            SCANCODE_RSHIFT
            SCANCODE_RALT
            SCANCODE_RGUI

            SCANCODE_MODE=257
            SCANCODE_AUDIONEXT
            SCANCODE_AUDIOPREV
            SCANCODE_AUDIOSTOP
            SCANCODE_AUDIOPLAY
            SCANCODE_AUDIOMUTE
            SCANCODE_MEDIASELECT
            SCANCODE_WWW
            SCANCODE_MAIL
            SCANCODE_CALCULATOR
            SCANCODE_COMPUTER
            SCANCODE_AC_SEARCH
            SCANCODE_AC_HOME
            SCANCODE_AC_BACK
            SCANCODE_AC_FORWARD
            SCANCODE_AC_STOP
            SCANCODE_AC_REFRESH
            SCANCODE_AC_BOOKMARKS
            SCANCODE_BRIGHTNESSDOWN
            SCANCODE_BRIGHTNESSUP
            SCANCODE_DISPLAYSWITCH
            SCANCODE_KBDILLUMTOGGLE
            SCANCODE_KBDILLUMDOWN
            SCANCODE_KBDILLUMUP
            SCANCODE_EJECT
            SCANCODE_SLEEP
            SCANCODE_APP1
            SCANCODE_APP2
            SCANCODE_AUDIOREWIND
            SCANCODE_AUDIOFASTFORWARD

            NUM_SCANCODES=512
        )],
        EventType => [qw(
            FIRSTEVENT=0

            QUIT=0x100

            APP_TERMINATING
            APP_LOWMEMORY
            APP_WILLENTERBACKGROUND
            APP_DIDENTERBACKGROUND
            APP_WILLENTERFOREGROUND
            APP_DIDENTERFOREGROUND

            LOCALECHANGED

            DISPLAYEVENT=0x150

            WINDOWEVENT=0x200
            SYSWMEVENT

            KEYDOWN=0x300
            KEYUP
            TEXTEDITING
            TEXTINPUT
            KEYMAPCHANGED

            MOUSEMOTION=0x400
            MOUSEBUTTONDOWN
            MOUSEBUTTONUP
            MOUSEWHEEL

            JOYAXISMOTION=0x600
            JOYBALLMOTION
            JOYHATMOTION
            JOYBUTTONDOWN
            JOYBUTTONUP
            JOYDEVICEADDED
            JOYDEVICEREMOVED

            CONTROLLERAXISMOTION=0x650
            CONTROLLERBUTTONDOWN
            CONTROLLERBUTTONUP
            CONTROLLERDEVICEADDED
            CONTROLLERDEVICEREMOVED
            CONTROLLERDEVICEREMAPPED
            CONTROLLERTOUCHPADDOWN
            CONTROLLERTOUCHPADMOTION
            CONTROLLERTOUCHPADUP
            CONTROLLERSENSORUPDATE

            FINGERDOWN=0x700
            FINGERUP
            FINGERMOTION

            DOLLARGESTURE=0x800
            DOLLARRECORD
            MULTIGESTURE

            CLIPBOARDUPDATE=0x900

            DROPFILE=0x1000
            DROPTEXT
            DROPBEGIN
            DROPCOMPLETE

            AUDIODEVICEADDED=0x1100
            AUDIODEVICEREMOVED

            SENSORUPDATE=0x1200

            RENDER_TARGETS_RESET=0x2000
            RENDER_DEVICE_RESET

            USEREVENT=0x8000

            LASTEVENT=0xFFFF
        )],
        SYSWM_TYPE => [qw(
           SYSWM_UNKNOWN
           SYSWM_WINDOWS
           SYSWM_X11
           SYSWM_DIRECTFB
           SYSWM_COCOA
           SYSWM_UIKIT
           SYSWM_WAYLAND
           SYSWM_MIR
           SYSWM_WINRT
           SYSWM_ANDROID
           SYSWM_VIVANTE
           SYSWM_OS2
           SYSWM_HAIKU
           SYSWM_KMSDRM
        )],
    );
}

BEGIN {
    enum(
        Keycode => {
            K_UNKNOWN            => 0,
            K_RETURN             => ord "\r",
            K_ESCAPE             => 27, # 033
            K_BACKSPACE          => ord "\b",
            K_TAB                => ord "\t",
            K_SPACE              => ord ' ',
            K_EXCLAIM            => ord '!',
            K_QUOTEDBL           => ord '"',
            K_HASH               => ord '#',
            K_PERCENT            => ord '%',
            K_DOLLAR             => ord '$',
            K_AMPERSAND          => ord '&',
            K_QUOTE              => ord "'",
            K_LEFTPAREN          => ord '(',
            K_RIGHTPAREN         => ord ')',
            K_ASTERISK           => ord '*',
            K_PLUS               => ord '+',
            K_COMMA              => ord ',',
            K_MINUS              => ord '-',
            K_PERIOD             => ord '.',
            K_SLASH              => ord '/',
            K_0                  => ord '0',
            K_1                  => ord '1',
            K_2                  => ord '2',
            K_3                  => ord '3',
            K_4                  => ord '4',
            K_5                  => ord '5',
            K_6                  => ord '6',
            K_7                  => ord '7',
            K_8                  => ord '8',
            K_9                  => ord '9',
            K_COLON              => ord ':',
            K_SEMICOLON          => ord ';',
            K_LESS               => ord '<',
            K_EQUALS             => ord '=',
            K_GREATER            => ord '>',
            K_QUESTION           => ord '?',
            K_AT                 => ord '@',
            K_LEFTBRACKET        => ord '[',
            K_BACKSLASH          => ord '\\',
            K_RIGHTBRACKET       => ord ']',
            K_CARET              => ord '^',
            K_UNDERSCORE         => ord '_',
            K_BACKQUOTE          => ord '`',
            K_a                  => ord 'a',
            K_b                  => ord 'b',
            K_c                  => ord 'c',
            K_d                  => ord 'd',
            K_e                  => ord 'e',
            K_f                  => ord 'f',
            K_g                  => ord 'g',
            K_h                  => ord 'h',
            K_i                  => ord 'i',
            K_j                  => ord 'j',
            K_k                  => ord 'k',
            K_l                  => ord 'l',
            K_m                  => ord 'm',
            K_n                  => ord 'n',
            K_o                  => ord 'o',
            K_p                  => ord 'p',
            K_q                  => ord 'q',
            K_r                  => ord 'r',
            K_s                  => ord 's',
            K_t                  => ord 't',
            K_u                  => ord 'u',
            K_v                  => ord 'v',
            K_w                  => ord 'w',
            K_x                  => ord 'x',
            K_y                  => ord 'y',
            K_z                  => ord 'z',

            K_CAPSLOCK           => SCANCODE_CAPSLOCK           | K_SCANCODE_MASK,

            K_F1                 => SCANCODE_F1                 | K_SCANCODE_MASK,
            K_F2                 => SCANCODE_F2                 | K_SCANCODE_MASK,
            K_F3                 => SCANCODE_F3                 | K_SCANCODE_MASK,
            K_F4                 => SCANCODE_F4                 | K_SCANCODE_MASK,
            K_F5                 => SCANCODE_F5                 | K_SCANCODE_MASK,
            K_F6                 => SCANCODE_F6                 | K_SCANCODE_MASK,
            K_F7                 => SCANCODE_F7                 | K_SCANCODE_MASK,
            K_F8                 => SCANCODE_F8                 | K_SCANCODE_MASK,
            K_F9                 => SCANCODE_F9                 | K_SCANCODE_MASK,
            K_F10                => SCANCODE_F10                | K_SCANCODE_MASK,
            K_F11                => SCANCODE_F11                | K_SCANCODE_MASK,
            K_F12                => SCANCODE_F12                | K_SCANCODE_MASK,

            K_PRINTSCREEN        => SCANCODE_PRINTSCREEN        | K_SCANCODE_MASK,
            K_SCROLLLOCK         => SCANCODE_SCROLLLOCK         | K_SCANCODE_MASK,
            K_PAUSE              => SCANCODE_PAUSE              | K_SCANCODE_MASK,
            K_INSERT             => SCANCODE_INSERT             | K_SCANCODE_MASK,
            K_HOME               => SCANCODE_HOME               | K_SCANCODE_MASK,
            K_PAGEUP             => SCANCODE_PAGEUP             | K_SCANCODE_MASK,
            K_DELETE             => 127, # 0177
            K_END                => SCANCODE_END                | K_SCANCODE_MASK,
            K_PAGEDOWN           => SCANCODE_PAGEDOWN           | K_SCANCODE_MASK,
            K_RIGHT              => SCANCODE_RIGHT              | K_SCANCODE_MASK,
            K_LEFT               => SCANCODE_LEFT               | K_SCANCODE_MASK,
            K_DOWN               => SCANCODE_DOWN               | K_SCANCODE_MASK,
            K_UP                 => SCANCODE_UP                 | K_SCANCODE_MASK,

            K_NUMLOCKCLEAR       => SCANCODE_NUMLOCKCLEAR       | K_SCANCODE_MASK,
            K_KP_DIVIDE          => SCANCODE_KP_DIVIDE          | K_SCANCODE_MASK,
            K_KP_MULTIPLY        => SCANCODE_KP_MULTIPLY        | K_SCANCODE_MASK,
            K_KP_MINUS           => SCANCODE_KP_MINUS           | K_SCANCODE_MASK,
            K_KP_PLUS            => SCANCODE_KP_PLUS            | K_SCANCODE_MASK,
            K_KP_ENTER           => SCANCODE_KP_ENTER           | K_SCANCODE_MASK,
            K_KP_1               => SCANCODE_KP_1               | K_SCANCODE_MASK,
            K_KP_2               => SCANCODE_KP_2               | K_SCANCODE_MASK,
            K_KP_3               => SCANCODE_KP_3               | K_SCANCODE_MASK,
            K_KP_4               => SCANCODE_KP_4               | K_SCANCODE_MASK,
            K_KP_5               => SCANCODE_KP_5               | K_SCANCODE_MASK,
            K_KP_6               => SCANCODE_KP_6               | K_SCANCODE_MASK,
            K_KP_7               => SCANCODE_KP_7               | K_SCANCODE_MASK,
            K_KP_8               => SCANCODE_KP_8               | K_SCANCODE_MASK,
            K_KP_9               => SCANCODE_KP_9               | K_SCANCODE_MASK,
            K_KP_0               => SCANCODE_KP_0               | K_SCANCODE_MASK,
            K_KP_PERIOD          => SCANCODE_KP_PERIOD          | K_SCANCODE_MASK,

            K_APPLICATION        => SCANCODE_APPLICATION        | K_SCANCODE_MASK,
            K_POWER              => SCANCODE_POWER              | K_SCANCODE_MASK,
            K_KP_EQUALS          => SCANCODE_KP_EQUALS          | K_SCANCODE_MASK,
            K_F13                => SCANCODE_F13                | K_SCANCODE_MASK,
            K_F14                => SCANCODE_F14                | K_SCANCODE_MASK,
            K_F15                => SCANCODE_F15                | K_SCANCODE_MASK,
            K_F16                => SCANCODE_F16                | K_SCANCODE_MASK,
            K_F17                => SCANCODE_F17                | K_SCANCODE_MASK,
            K_F18                => SCANCODE_F18                | K_SCANCODE_MASK,
            K_F19                => SCANCODE_F19                | K_SCANCODE_MASK,
            K_F20                => SCANCODE_F20                | K_SCANCODE_MASK,
            K_F21                => SCANCODE_F21                | K_SCANCODE_MASK,
            K_F22                => SCANCODE_F22                | K_SCANCODE_MASK,
            K_F23                => SCANCODE_F23                | K_SCANCODE_MASK,
            K_F24                => SCANCODE_F24                | K_SCANCODE_MASK,
            K_EXECUTE            => SCANCODE_EXECUTE            | K_SCANCODE_MASK,
            K_HELP               => SCANCODE_HELP               | K_SCANCODE_MASK,
            K_MENU               => SCANCODE_MENU               | K_SCANCODE_MASK,
            K_SELECT             => SCANCODE_SELECT             | K_SCANCODE_MASK,
            K_STOP               => SCANCODE_STOP               | K_SCANCODE_MASK,
            K_AGAIN              => SCANCODE_AGAIN              | K_SCANCODE_MASK,
            K_UNDO               => SCANCODE_UNDO               | K_SCANCODE_MASK,
            K_CUT                => SCANCODE_CUT                | K_SCANCODE_MASK,
            K_COPY               => SCANCODE_COPY               | K_SCANCODE_MASK,
            K_PASTE              => SCANCODE_PASTE              | K_SCANCODE_MASK,
            K_FIND               => SCANCODE_FIND               | K_SCANCODE_MASK,
            K_MUTE               => SCANCODE_MUTE               | K_SCANCODE_MASK,
            K_VOLUMEUP           => SCANCODE_VOLUMEUP           | K_SCANCODE_MASK,
            K_VOLUMEDOWN         => SCANCODE_VOLUMEDOWN         | K_SCANCODE_MASK,
            K_KP_COMMA           => SCANCODE_KP_COMMA           | K_SCANCODE_MASK,
            K_KP_EQUALSAS400     => SCANCODE_KP_EQUALSAS400     | K_SCANCODE_MASK,

            K_ALTERASE           => SCANCODE_ALTERASE           | K_SCANCODE_MASK,
            K_SYSREQ             => SCANCODE_SYSREQ             | K_SCANCODE_MASK,
            K_CANCEL             => SCANCODE_CANCEL             | K_SCANCODE_MASK,
            K_CLEAR              => SCANCODE_CLEAR              | K_SCANCODE_MASK,
            K_PRIOR              => SCANCODE_PRIOR              | K_SCANCODE_MASK,
            K_RETURN2            => SCANCODE_RETURN2            | K_SCANCODE_MASK,
            K_SEPARATOR          => SCANCODE_SEPARATOR          | K_SCANCODE_MASK,
            K_OUT                => SCANCODE_OUT                | K_SCANCODE_MASK,
            K_OPER               => SCANCODE_OPER               | K_SCANCODE_MASK,
            K_CLEARAGAIN         => SCANCODE_CLEARAGAIN         | K_SCANCODE_MASK,
            K_CRSEL              => SCANCODE_CRSEL              | K_SCANCODE_MASK,
            K_EXSEL              => SCANCODE_EXSEL              | K_SCANCODE_MASK,

            K_KP_00              => SCANCODE_KP_00              | K_SCANCODE_MASK,
            K_KP_000             => SCANCODE_KP_000             | K_SCANCODE_MASK,
            K_THOUSANDSSEPARATOR => SCANCODE_THOUSANDSSEPARATOR | K_SCANCODE_MASK,
            K_DECIMALSEPARATOR   => SCANCODE_DECIMALSEPARATOR   | K_SCANCODE_MASK,
            K_CURRENCYUNIT       => SCANCODE_CURRENCYUNIT       | K_SCANCODE_MASK,
            K_CURRENCYSUBUNIT    => SCANCODE_CURRENCYSUBUNIT    | K_SCANCODE_MASK,
            K_KP_LEFTPAREN       => SCANCODE_KP_LEFTPAREN       | K_SCANCODE_MASK,
            K_KP_RIGHTPAREN      => SCANCODE_KP_RIGHTPAREN      | K_SCANCODE_MASK,
            K_KP_LEFTBRACE       => SCANCODE_KP_LEFTBRACE       | K_SCANCODE_MASK,
            K_KP_RIGHTBRACE      => SCANCODE_KP_RIGHTBRACE      | K_SCANCODE_MASK,
            K_KP_TAB             => SCANCODE_KP_TAB             | K_SCANCODE_MASK,
            K_KP_BACKSPACE       => SCANCODE_KP_BACKSPACE       | K_SCANCODE_MASK,
            K_KP_A               => SCANCODE_KP_A               | K_SCANCODE_MASK,
            K_KP_B               => SCANCODE_KP_B               | K_SCANCODE_MASK,
            K_KP_C               => SCANCODE_KP_C               | K_SCANCODE_MASK,
            K_KP_D               => SCANCODE_KP_D               | K_SCANCODE_MASK,
            K_KP_E               => SCANCODE_KP_E               | K_SCANCODE_MASK,
            K_KP_F               => SCANCODE_KP_F               | K_SCANCODE_MASK,
            K_KP_XOR             => SCANCODE_KP_XOR             | K_SCANCODE_MASK,
            K_KP_POWER           => SCANCODE_KP_POWER           | K_SCANCODE_MASK,
            K_KP_PERCENT         => SCANCODE_KP_PERCENT         | K_SCANCODE_MASK,
            K_KP_LESS            => SCANCODE_KP_LESS            | K_SCANCODE_MASK,
            K_KP_GREATER         => SCANCODE_KP_GREATER         | K_SCANCODE_MASK,
            K_KP_AMPERSAND       => SCANCODE_KP_AMPERSAND       | K_SCANCODE_MASK,
            K_KP_DBLAMPERSAND    => SCANCODE_KP_DBLAMPERSAND    | K_SCANCODE_MASK,
            K_KP_VERTICALBAR     => SCANCODE_KP_VERTICALBAR     | K_SCANCODE_MASK,
            K_KP_DBLVERTICALBAR  => SCANCODE_KP_DBLVERTICALBAR  | K_SCANCODE_MASK,
            K_KP_COLON           => SCANCODE_KP_COLON           | K_SCANCODE_MASK,
            K_KP_HASH            => SCANCODE_KP_HASH            | K_SCANCODE_MASK,
            K_KP_SPACE           => SCANCODE_KP_SPACE           | K_SCANCODE_MASK,
            K_KP_AT              => SCANCODE_KP_AT              | K_SCANCODE_MASK,
            K_KP_EXCLAM          => SCANCODE_KP_EXCLAM          | K_SCANCODE_MASK,
            K_KP_MEMSTORE        => SCANCODE_KP_MEMSTORE        | K_SCANCODE_MASK,
            K_KP_MEMRECALL       => SCANCODE_KP_MEMRECALL       | K_SCANCODE_MASK,
            K_KP_MEMCLEAR        => SCANCODE_KP_MEMCLEAR        | K_SCANCODE_MASK,
            K_KP_MEMADD          => SCANCODE_KP_MEMADD          | K_SCANCODE_MASK,
            K_KP_MEMSUBTRACT     => SCANCODE_KP_MEMSUBTRACT     | K_SCANCODE_MASK,
            K_KP_MEMMULTIPLY     => SCANCODE_KP_MEMMULTIPLY     | K_SCANCODE_MASK,
            K_KP_MEMDIVIDE       => SCANCODE_KP_MEMDIVIDE       | K_SCANCODE_MASK,
            K_KP_PLUSMINUS       => SCANCODE_KP_PLUSMINUS       | K_SCANCODE_MASK,
            K_KP_CLEAR           => SCANCODE_KP_CLEAR           | K_SCANCODE_MASK,
            K_KP_CLEARENTRY      => SCANCODE_KP_CLEARENTRY      | K_SCANCODE_MASK,
            K_KP_BINARY          => SCANCODE_KP_BINARY          | K_SCANCODE_MASK,
            K_KP_OCTAL           => SCANCODE_KP_OCTAL           | K_SCANCODE_MASK,
            K_KP_DECIMAL         => SCANCODE_KP_DECIMAL         | K_SCANCODE_MASK,
            K_KP_HEXADECIMAL     => SCANCODE_KP_HEXADECIMAL     | K_SCANCODE_MASK,

            K_LCTRL              => SCANCODE_LCTRL              | K_SCANCODE_MASK,
            K_LSHIFT             => SCANCODE_LSHIFT             | K_SCANCODE_MASK,
            K_LALT               => SCANCODE_LALT               | K_SCANCODE_MASK,
            K_LGUI               => SCANCODE_LGUI               | K_SCANCODE_MASK,
            K_RCTRL              => SCANCODE_RCTRL              | K_SCANCODE_MASK,
            K_RSHIFT             => SCANCODE_RSHIFT             | K_SCANCODE_MASK,
            K_RALT               => SCANCODE_RALT               | K_SCANCODE_MASK,
            K_RGUI               => SCANCODE_RGUI               | K_SCANCODE_MASK,

            K_MODE               => SCANCODE_MODE               | K_SCANCODE_MASK,

            K_AUDIONEXT          => SCANCODE_AUDIONEXT          | K_SCANCODE_MASK,
            K_AUDIOPREV          => SCANCODE_AUDIOPREV          | K_SCANCODE_MASK,
            K_AUDIOSTOP          => SCANCODE_AUDIOSTOP          | K_SCANCODE_MASK,
            K_AUDIOPLAY          => SCANCODE_AUDIOPLAY          | K_SCANCODE_MASK,
            K_AUDIOMUTE          => SCANCODE_AUDIOMUTE          | K_SCANCODE_MASK,
            K_MEDIASELECT        => SCANCODE_MEDIASELECT        | K_SCANCODE_MASK,
            K_WWW                => SCANCODE_WWW                | K_SCANCODE_MASK,
            K_MAIL               => SCANCODE_MAIL               | K_SCANCODE_MASK,
            K_CALCULATOR         => SCANCODE_CALCULATOR         | K_SCANCODE_MASK,
            K_COMPUTER           => SCANCODE_COMPUTER           | K_SCANCODE_MASK,
            K_AC_SEARCH          => SCANCODE_AC_SEARCH          | K_SCANCODE_MASK,
            K_AC_HOME            => SCANCODE_AC_HOME            | K_SCANCODE_MASK,
            K_AC_BACK            => SCANCODE_AC_BACK            | K_SCANCODE_MASK,
            K_AC_FORWARD         => SCANCODE_AC_FORWARD         | K_SCANCODE_MASK,
            K_AC_STOP            => SCANCODE_AC_STOP            | K_SCANCODE_MASK,
            K_AC_REFRESH         => SCANCODE_AC_REFRESH         | K_SCANCODE_MASK,
            K_AC_BOOKMARKS       => SCANCODE_AC_BOOKMARKS       | K_SCANCODE_MASK,

            K_BRIGHTNESSDOWN     => SCANCODE_BRIGHTNESSDOWN     | K_SCANCODE_MASK,
            K_BRIGHTNESSUP       => SCANCODE_BRIGHTNESSUP       | K_SCANCODE_MASK,
            K_DISPLAYSWITCH      => SCANCODE_DISPLAYSWITCH      | K_SCANCODE_MASK,
            K_KBDILLUMTOGGLE     => SCANCODE_KBDILLUMTOGGLE     | K_SCANCODE_MASK,
            K_KBDILLUMDOWN       => SCANCODE_KBDILLUMDOWN       | K_SCANCODE_MASK,
            K_KBDILLUMUP         => SCANCODE_KBDILLUMUP         | K_SCANCODE_MASK,
            K_EJECT              => SCANCODE_EJECT              | K_SCANCODE_MASK,
            K_SLEEP              => SCANCODE_SLEEP              | K_SCANCODE_MASK,
            K_APP1               => SCANCODE_APP1               | K_SCANCODE_MASK,
            K_APP2               => SCANCODE_APP2               | K_SCANCODE_MASK,

            K_AUDIOREWIND        => SCANCODE_AUDIOREWIND        | K_SCANCODE_MASK,
            K_AUDIOFASTFORWARD   => SCANCODE_AUDIOFASTFORWARD   | K_SCANCODE_MASK,
        },
        PixelFormatEnum => {
            PIXELFORMAT_UNKNOWN     => 0,
            PIXELFORMAT_INDEX1LSB   => pixel_format( PIXELTYPE_INDEX1,   BITMAPORDER_4321, 0,                     1, 0 ),
            PIXELFORMAT_INDEX1MSB   => pixel_format( PIXELTYPE_INDEX1,   BITMAPORDER_1234, 0,                     1, 0 ),
            PIXELFORMAT_INDEX4LSB   => pixel_format( PIXELTYPE_INDEX4,   BITMAPORDER_4321, 0,                     4, 0 ),
            PIXELFORMAT_INDEX4MSB   => pixel_format( PIXELTYPE_INDEX4,   BITMAPORDER_1234, 0,                     4, 0 ),
            PIXELFORMAT_INDEX8      => pixel_format( PIXELTYPE_INDEX8,   0,                0,                     8, 1 ),
            PIXELFORMAT_RGB332      => pixel_format( PIXELTYPE_PACKED8,  PACKEDORDER_XRGB, PACKEDLAYOUT_332,      8, 1 ),
            PIXELFORMAT_XRGB4444    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_XRGB, PACKEDLAYOUT_4444,    12, 2 ),
            PIXELFORMAT_XBGR4444    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_XBGR, PACKEDLAYOUT_4444,    12, 2 ),
            PIXELFORMAT_XRGB1555    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_XRGB, PACKEDLAYOUT_1555,    15, 2 ),
            PIXELFORMAT_XBGR1555    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_XBGR, PACKEDLAYOUT_1555,    15, 2 ),
            PIXELFORMAT_ARGB4444    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_ARGB, PACKEDLAYOUT_4444,    16, 2 ),
            PIXELFORMAT_RGBA4444    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_RGBA, PACKEDLAYOUT_4444,    16, 2 ),
            PIXELFORMAT_ABGR4444    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_ABGR, PACKEDLAYOUT_4444,    16, 2 ),
            PIXELFORMAT_BGRA4444    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_BGRA, PACKEDLAYOUT_4444,    16, 2 ),
            PIXELFORMAT_ARGB1555    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_ARGB, PACKEDLAYOUT_1555,    16, 2 ),
            PIXELFORMAT_RGBA5551    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_RGBA, PACKEDLAYOUT_5551,    16, 2 ),
            PIXELFORMAT_ABGR1555    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_ABGR, PACKEDLAYOUT_1555,    16, 2 ),
            PIXELFORMAT_BGRA5551    => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_BGRA, PACKEDLAYOUT_5551,    16, 2 ),
            PIXELFORMAT_RGB565      => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_XRGB, PACKEDLAYOUT_565,     16, 2 ),
            PIXELFORMAT_BGR565      => pixel_format( PIXELTYPE_PACKED16, PACKEDORDER_XBGR, PACKEDLAYOUT_565,     16, 2 ),
            PIXELFORMAT_RGB24       => pixel_format( PIXELTYPE_ARRAYU8,  ARRAYORDER_RGB,   0,                    24, 3 ),
            PIXELFORMAT_BGR24       => pixel_format( PIXELTYPE_ARRAYU8,  ARRAYORDER_BGR,   0,                    24, 3 ),
            PIXELFORMAT_XRGB8888    => pixel_format( PIXELTYPE_PACKED32, PACKEDORDER_XRGB, PACKEDLAYOUT_8888,    24, 4 ),
            PIXELFORMAT_RGBX8888    => pixel_format( PIXELTYPE_PACKED32, PACKEDORDER_RGBX, PACKEDLAYOUT_8888,    24, 4 ),
            PIXELFORMAT_XBGR8888    => pixel_format( PIXELTYPE_PACKED32, PACKEDORDER_XBGR, PACKEDLAYOUT_8888,    24, 4 ),
            PIXELFORMAT_BGRX8888    => pixel_format( PIXELTYPE_PACKED32, PACKEDORDER_BGRX, PACKEDLAYOUT_8888,    24, 4 ),
            PIXELFORMAT_ARGB8888    => pixel_format( PIXELTYPE_PACKED32, PACKEDORDER_ARGB, PACKEDLAYOUT_8888,    32, 4 ),
            PIXELFORMAT_RGBA8888    => pixel_format( PIXELTYPE_PACKED32, PACKEDORDER_RGBA, PACKEDLAYOUT_8888,    32, 4 ),
            PIXELFORMAT_ABGR8888    => pixel_format( PIXELTYPE_PACKED32, PACKEDORDER_ABGR, PACKEDLAYOUT_8888,    32, 4 ),
            PIXELFORMAT_BGRA8888    => pixel_format( PIXELTYPE_PACKED32, PACKEDORDER_BGRA, PACKEDLAYOUT_8888,    32, 4 ),
            PIXELFORMAT_ARGB2101010 => pixel_format( PIXELTYPE_PACKED32, PACKEDORDER_ARGB, PACKEDLAYOUT_2101010, 32, 4 ),
            # Continued below
        },
    );
}

BEGIN {
    enum(
        PixelFormatEnum => {
            # Continued from above
            PIXELFORMAT_RGB444 => PIXELFORMAT_XRGB4444,
            PIXELFORMAT_BGR444 => PIXELFORMAT_XBGR4444,
            PIXELFORMAT_RGB555 => PIXELFORMAT_XRGB1555,
            PIXELFORMAT_BGR555 => PIXELFORMAT_XBGR1555,
            PIXELFORMAT_RGB888 => PIXELFORMAT_XRGB8888,
            PIXELFORMAT_BGR888 => PIXELFORMAT_XBGR8888,
            # Continued below
        }
    );
}

BEGIN {
    my $define_fourcc = sub { ord(shift) << 0 | ord(shift) << 8 | ord(shift) << 16 | ord(shift) << 24 };

    enum(
        PixelFormatEnum => {
            # Continued from above
            ( BYTEORDER == BIG_ENDIAN ) ? (
                PIXELFORMAT_RGBA32 => PIXELFORMAT_RGBA8888,
                PIXELFORMAT_ARGB32 => PIXELFORMAT_ARGB8888,
                PIXELFORMAT_BGRA32 => PIXELFORMAT_BGRA8888,
                PIXELFORMAT_ABGR32 => PIXELFORMAT_ABGR8888,
            ) : (
                PIXELFORMAT_RGBA32 => PIXELFORMAT_ABGR8888,
                PIXELFORMAT_ARGB32 => PIXELFORMAT_BGRA8888,
                PIXELFORMAT_BGRA32 => PIXELFORMAT_ARGB8888,
                PIXELFORMAT_ABGR32 => PIXELFORMAT_RGBA8888,
            ),
            PIXELFORMAT_YV12         => $define_fourcc->( 'Y', 'V', '1', '2' ),
            PIXELFORMAT_IYUV         => $define_fourcc->( 'I', 'Y', 'U', 'V' ),
            PIXELFORMAT_YUY2         => $define_fourcc->( 'Y', 'U', 'Y', '2' ),
            PIXELFORMAT_UYVY         => $define_fourcc->( 'U', 'Y', 'V', 'Y' ),
            PIXELFORMAT_YVYU         => $define_fourcc->( 'Y', 'V', 'Y', 'U' ),
            PIXELFORMAT_NV12         => $define_fourcc->( 'N', 'V', '1', '2' ),
            PIXELFORMAT_NV21         => $define_fourcc->( 'N', 'V', '2', '1' ),
            PIXELFORMAT_EXTERNAL_OES => $define_fourcc->( 'O', 'E', 'S', ' ' ),
        }
    );
}

$ffi->type( sint32 => 'SDL_BlendMode'  );
$ffi->type( sint32 => 'SDL_JoystickID' );
$ffi->type( sint64 => 'SDL_TouchID'    );
$ffi->type( sint64 => 'SDL_FingerID'   );
$ffi->type( sint64 => 'SDL_GestureID'  );

$ffi->mangler( sub { 'SDL_' . shift } );

package SDL2::Finger {
    FFI::C->struct( SDL_Finger => [
        id       => 'SDL_FingerID',
        x        => 'float',
        y        => 'float',
        pressure => 'float',
    ]);
}

package SDL2::AudioDeviceEvent {
    FFI::C->struct( SDL_AudioDeviceEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'uint32',
        iscapture => 'uint8',
        padding1  => 'uint8',
        padding2  => 'uint8',
        padding3  => 'uint8',
    ]);
}

package SDL2::ControllerAxisEvent {
    FFI::C->struct( SDL_ControllerAxisEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'SDL_JoystickID',
        axis      => 'uint8',
        padding1  => 'uint8',
        padding2  => 'uint8',
        padding3  => 'uint8',
        value     => 'sint16',
        padding4  => 'uint16',
    ]);
}

package SDL2::ControllerButtonEvent {
    FFI::C->struct( SDL_ControllerButtonEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'SDL_JoystickID',
        button    => 'uint8',
        state     => 'uint8',
        padding1  => 'uint8',
        padding2  => 'uint8',
    ]);
}

package SDL2::ControllerDeviceEvent {
    FFI::C->struct( SDL_ControllerDeviceEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'SDL_JoystickID',
    ]);
}

package SDL2::ControllerTouchpadEvent {
    FFI::C->struct( SDL_ControllerTouchpadEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'SDL_JoystickID',
        touchpad  => 'sint32',
        finger    => 'sint32',
        x         => 'float',
        y         => 'float',
        pressure  => 'float',
    ]);
}

package SDL2::ControllerSensorEvent {
    FFI::C->struct( SDL_ControllerSensorEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'SDL_JoystickID',
        data      => 'float[3]',
    ]);
}

package SDL2::DisplayEvent {
    FFI::C->struct( SDL_DisplayEvent => [
        type       => 'uint32',
        timestamp  => 'uint32',
        display    => 'uint32',
        event      => 'uint8',
        padding1   => 'uint8',
        padding2   => 'uint8',
        padding3   => 'uint8',
        data1      => 'sint32',
    ]);
}

package SDL2::DollarGestureEvent {
    FFI::C->struct( SDL_DollarGestureEvent => [
        type       => 'uint32',
        timestamp  => 'uint32',
        touchId    => 'SDL_TouchID',
        gestureId  => 'SDL_GestureID',
        numFingers => 'uint32',
        error      => 'float',
        x          => 'float',
        y          => 'float',
    ]);
}

package SDL2::DropEvent {
    FFI::C->struct( SDL_DropEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        _file     => 'opaque',
        windowID  => 'uint32',
    ]);

    sub file { $ffi->cast( opaque => string => shift->_file ) }
}

package SDL2::JoyAxisEvent {
    FFI::C->struct( SDL_JoyAxisEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'SDL_JoystickID',
        axis      => 'uint8',
        padding1  => 'uint8',
        padding2  => 'uint8',
        padding3  => 'uint8',
        value     => 'sint16',
        padding4  => 'uint16',
    ]);
}

package SDL2::JoyBallEvent {
    FFI::C->struct( SDL_JoyBallEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'SDL_JoystickID',
        ball      => 'uint8',
        padding1  => 'uint8',
        padding2  => 'uint8',
        padding3  => 'uint8',
        xrel      => 'sint16',
        yrel      => 'sint16',
    ]);
}

package SDL2::JoyButtonEvent {
    FFI::C->struct( SDL_JoyButtonEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'SDL_JoystickID',
        button    => 'uint8',
        state     => 'uint8',
        padding1  => 'uint8',
        padding2  => 'uint8',
    ]);
}

package SDL2::JoyDeviceEvent {
    FFI::C->struct( SDL_JoyDeviceEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'SDL_JoystickID',
    ]);
}

package SDL2::JoyHatEvent {
    FFI::C->struct( SDL_JoyHatEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'SDL_JoystickID',
        hat       => 'uint8',
        value     => 'uint8',
        padding1  => 'uint8',
        padding2  => 'uint8',
    ]);
}

package SDL2::KeyboardEvent {
    FFI::C->struct( SDL_KeyboardEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        windowID  => 'uint32',
        state     => 'uint8',
        repeat    => 'uint8',
        scancode  => 'sint32',
        sym       => 'sint32',
        mod       => 'uint16',
    ]);
}

package SDL2::MouseButtonEvent {
    FFI::C->struct( SDL_MouseButtonEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        windowID  => 'uint32',
        which     => 'uint32',
        button    => 'uint8',
        state     => 'uint8',
        clicks    => 'uint8',
        padding1  => 'uint8',
        x         => 'sint32',
        y         => 'sint32',
    ]);
}

package SDL2::MouseMotionEvent {
    FFI::C->struct( SDL_MouseMotionEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        windowID  => 'uint32',
        which     => 'uint32',
        state     => 'uint32',
        x         => 'sint32',
        y         => 'sint32',
        xrel      => 'sint32',
        yrel      => 'sint32',
    ]);
}

package SDL2::MouseWheelEvent {
    FFI::C->struct( SDL_MouseWheelEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        windowID  => 'uint32',
        which     => 'uint32',
        x         => 'sint32',
        y         => 'sint32',
        direction => 'uint32',
    ]);
}

package SDL2::MultiGestureEvent {
    FFI::C->struct( SDL_MultiGestureEvent => [
        type       => 'uint32',
        timestamp  => 'uint32',
        touchId    => 'SDL_TouchID',
        dThetha    => 'float',
        dHist      => 'float',
        x          => 'float',
        y          => 'float',
        numFingers => 'uint16',
        padding    => 'uint16',
    ]);
}

package SDL2::OSEvent {
    FFI::C->struct( SDL_OSEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
    ]);
}

package SDL2::QuitEvent {
    FFI::C->struct( SDL_QuitEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
    ]);
}

package SDL2::SensorEvent {
    FFI::C->struct( SDL_SensorEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        which     => 'sint32',
        data      => 'float[6]',
    ]);
}

package SDL2::SysWMEvent {
    FFI::C->struct( SDL_SysWMEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        msg       => 'opaque', # TODO: driver dependent data
    ]);
}

package SDL2::TextEditingEvent {
    FFI::C->struct( SDL_TextEditingEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        windowID  => 'uint32',
        _text     => 'string(32)',
        start     => 'sint32',
        length    => 'sint32',
    ]);

    sub text { my $data = shift->_text; substr $data, 0, index $data, "\0" }
}

package SDL2::TextInputEvent {
    FFI::C->struct( SDL_TextInputEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        windowID  => 'uint32',
        _text     => 'string(32)',
    ]);

    sub text { my $data = shift->_text; substr $data, 0, index $data, "\0" }
}

package SDL2::TouchFingerEvent {
    FFI::C->struct( SDL_TouchFingerEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        touchId   => 'SDL_TouchID',
        fingerID  => 'SDL_FingerID',
        x         => 'float',
        y         => 'float',
        dx        => 'float',
        dy        => 'float',
        pressure  => 'float',
    ]);
}

package SDL2::UserEvent {
    FFI::C->struct( SDL_UserEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        windowID  => 'uint32',
        code      => 'sint32',
        data1     => 'opaque',
        data2     => 'opaque',
    ]);

    sub file { $ffi->cast( opaque => string => shift->_file ) }
}

package SDL2::WindowEvent {
    FFI::C->struct( SDL_WindowEvent => [
        type      => 'uint32',
        timestamp => 'uint32',
        windowID  => 'uint32',
        event     => 'uint8',
        padding1  => 'uint8',
        padding2  => 'uint8',
        padding3  => 'uint8',
        data1     => 'sint32',
        data2     => 'sint32',
    ]);
}

package SDL2::Event {
    FFI::C->union( SDL_Event => [
        type      => 'uint32',
        timestamp => 'uint32',

        adevice   => 'SDL_AudioDeviceEvent',
        button    => 'SDL_MouseButtonEvent',
        caxis     => 'SDL_ControllerAxisEvent',
        cbutton   => 'SDL_ControllerButtonEvent',
        cdevice   => 'SDL_ControllerDeviceEvent',
        csensor   => 'SDL_ControllerSensorEvent',
        ctouchpad => 'SDL_ControllerTouchpadEvent',
        dgesture  => 'SDL_DollarGestureEvent',
        display   => 'SDL_DisplayEvent',
        drop      => 'SDL_DropEvent',
        edit      => 'SDL_TextEditingEvent',
        jaxis     => 'SDL_JoyAxisEvent',
        jball     => 'SDL_JoyBallEvent',
        jbutton   => 'SDL_JoyButtonEvent',
        jdevide   => 'SDL_JoyDeviceEvent',
        jhat      => 'SDL_JoyHatEvent',
        key       => 'SDL_KeyboardEvent',
        mgesture  => 'SDL_MultiGestureEvent',
        motion    => 'SDL_MouseMotionEvent',
        quit      => 'SDL_QuitEvent',
        sensor    => 'SDL_SensorEvent',
        syswm     => 'SDL_SysWMEvent',
        text      => 'SDL_TextInputEvent',
        tfinger   => 'SDL_TouchFingerEvent',
        user      => 'SDL_UserEvent',
        wheel     => 'SDL_MouseWheelEvent',
        window    => 'SDL_WindowEvent',

        padding   => 'uint8[56]',
    ]);
}

package SDL2::PixelFormat {
    FFI::C->struct( SDL_PixelFormat => [
        format        => 'uint32',
        palette       => 'opaque',
        BitsPerPixel  => 'uint8',
        BytesPerPixel => 'uint8',
        padding1      => 'uint8',
        padding2      => 'uint8',
        Rmask         => 'uint32',
        Gmask         => 'uint32',
        Bmask         => 'uint32',
        Amask         => 'uint32',
        Rloss         => 'uint8',
        Gloss         => 'uint8',
        Bloss         => 'uint8',
        Aloss         => 'uint8',
        Rshift        => 'uint8',
        Gshift        => 'uint8',
        Bshift        => 'uint8',
        Ashift        => 'uint8',
        refcount      => 'int',
        _next         => 'opaque',
    ]);

    sub next { $ffi->cast( opaque => 'SDL_PixelFormat', shift ) }
}

package SDL2::Surface {
    FFI::C->struct( SDL_Surface => [
        flags  => 'uint32',
        format => 'opaque',
        w      => 'int',
        h      => 'int',
        pitch  => 'int',
    ]);
}

package SDL2::Rect {
    use FFI::Platypus::Record;
    record_layout_1( int => 'x', int => 'y', int => 'w', int => 'h' );

    {
        # Give rect a positional constructor
        no strict 'refs';
        no warnings 'redefine';

        my $old  = __PACKAGE__->can('new') or die;
        my $new  = sub {
            shift->$old({ x => shift, y => shift, w => shift, h => shift });
        };
        my $name = __PACKAGE__ . '::new';

        require Sub::Util;
        *{$name} = Sub::Util::set_subname $name => $new;
    }
}

package SDL2::Point {
    use FFI::Platypus::Record;
    record_layout_1( int => 'x', int => 'y' );

    {
        # Give point a positional constructor
        no strict 'refs';
        no warnings 'redefine';

        my $old  = __PACKAGE__->can('new') or die;
        my $new  = sub { shift->$old({ x => shift, y => shift }) };
        my $name = __PACKAGE__ . '::new';

        require Sub::Util;
        *{$name} = Sub::Util::set_subname $name => $new;
    }
}

package SDL2::RendererInfo {
    FFI::C->struct( SDL_RendererInfo => [
        '_name'               => 'opaque',
        flags                 => 'uint32',
        'num_texture_formats' => 'uint32',
        'texture_formats'     => 'uint32[16]',
        'max_texture_width'   => 'int',
        'max_texture_height'  => 'int',
    ]);

    sub name { $ffi->cast( opaque => string => shift->_name ) }
}

package SDL2::Version {
    FFI::C->struct( SDL_Version => [
        major => 'uint8',
        minor => 'uint8',
        patch => 'uint8',
    ]);
}

package SDL2::SysWMinfo {
    FFI::C->struct( SDL_SysWMinfo => [
        version   => 'SDL_Version',
        subsystem => 'int',
    ]);
}

$ffi->type( 'record(SDL2::Rect)'  => 'SDL_Rect'  );
$ffi->type( 'record(SDL2::Point)' => 'SDL_Point' );

$ffi->type( opaque => 'SDL_Renderer'       );
$ffi->type( opaque => 'SDL_Texture'        );
$ffi->type( opaque => 'SDL_Window'         );
$ffi->type( opaque => 'SDL_GameController' );
$ffi->type( opaque => 'SDL_Joystick'       );
$ffi->type( opaque => 'SDL_RWops'          );

## Video

$ffi->attach( CreateWindow => [qw( string sint32 sint32 sint32 sint32 sint32 )] => 'SDL_Window' );
# SDL_CreateWindowFrom
$ffi->attach( DestroyWindow => ['SDL_Window' ] => 'void' );
# SDL_DisableScreenSaver
# SDL_DisplayMode
# SDL_EnableScreenSaver
# SDL_GetClosestDisplayMode
# SDL_GetCurrentDisplayMode
# SDL_GetCurrentVideoDriver
# SDL_GetDesktopDisplayMode
# SDL_GetDisplayBounds
# SDL_GetDisplayDPI
# SDL_GetDisplayMode
# SDL_GetDisplayName
# SDL_GetDisplayUsableBounds
# SDL_GetGrabbedWindow
# SDL_GetNumDisplayModes
# SDL_GetNumVideoDisplays
# SDL_GetNumVideoDrivers
# SDL_GetVideoDriver
# SDL_GetWindowBordersSize
# SDL_GetWindowBrightness
# SDL_GetWindowData
# SDL_GetWindowDisplayIndex
# SDL_GetWindowDisplayMode
# SDL_GetWindowFlags
# SDL_GetWindowFromID
# SDL_GetWindowGammaRamp
# SDL_GetWindowGrab
# SDL_GetWindowID
# SDL_GetWindowMaximumSize
# SDL_GetWindowMinimumSize
# SDL_GetWindowOpacity
# SDL_GetWindowPixelFormat
# SDL_GetWindowPosition
# SDL_GetWindowSize
$ffi->attach( GetWindowSurface => ['SDL_Window'] => 'SDL_Surface' );
$ffi->attach( GetWindowTitle   => ['SDL_Window'] => 'string' );
$ffi->attach( GetWindowWMInfo  => ['SDL_Window', 'SDL_SysWMinfo'] => 'int' );
# SDL_GL_CreateContext
# SDL_GL_DeleteContext
# SDL_GL_ExtensionSupported
# SDL_GL_GetAttribute
# SDL_GL_GetCurrentContext
# SDL_GL_GetCurrentWindow
# SDL_GL_GetDrawableSize
# SDL_GL_GetProcAddress
# SDL_GL_GetSwapInterval
# SDL_GL_LoadLibrary
# SDL_GL_MakeCurrent
# SDL_GL_ResetAttributes
# SDL_GL_SetAttribute
# SDL_GL_SetSwapInterval
# SDL_GL_SwapWindow
# SDL_GL_UnloadLibrary
# SDL_GLattr
# SDL_GLcontextFlag
# SDL_GLprofile
# SDL_HideWindow
# SDL_HitTestResult
# SDL_IsScreenSaverEnabled
# SDL_MaximizeWindow
# SDL_MessageBoxButtonData
# SDL_MessageBoxButtonFlags
# SDL_MessageBoxColor
# SDL_MessageBoxColorScheme
# SDL_MessageBoxColorType
# SDL_MessageBoxData
# SDL_MessageBoxFlags
# SDL_MinimizeWindow
# SDL_RaiseWindow
# SDL_RestoreWindow
# SDL_SetWindowBordered
# SDL_SetWindowBrightness
# SDL_SetWindowData
# SDL_SetWindowDisplayMode
# SDL_SetWindowFullscreen
# SDL_SetWindowGammaRamp
# SDL_SetWindowGrab
# SDL_SetWindowHitTest
$ffi->attach( SetWindowIcon => ['SDL_Window', 'SDL_Surface'] => 'void' );
# SDL_SetWindowInputFocus
# SDL_SetWindowMaximumSize
# SDL_SetWindowMinimumSize
# SDL_SetWindowModalFor
# SDL_SetWindowOpacity
# SDL_SetWindowPosition
# SDL_SetWindowResizable
# SDL_SetWindowSize
$ffi->attach( SetWindowTitle => ['SDL_Window', 'string'] => 'void' );
# SDL_ShowMessageBox
# SDL_ShowSimpleMessageBox
# SDL_ShowWindow
$ffi->attach( UpdateWindowSurface => ['SDL_Window' ] => 'int' );
# SDL_UpdateWindowSurfaceRects
# SDL_VideoInit
# SDL_VideoQuit
# SDL_WindowEvent
# SDL_WindowEventID
# SDL_WindowFlags

## SDL

$ffi->attach( Init          => ['uint32'] => 'int'  );
$ffi->attach( InitSubSystem => ['uint32'] => 'int'  );
$ffi->attach( Quit          => [        ] => 'void' );
$ffi->attach( QuitSubSystem => ['uint32'] => 'void' );
$ffi->attach( WasInit       => ['uint32'] => 'int'  );
# SDL_SetMainReady
# SDL_WinRTRunApp

## Timer

# SDL_AddTimer
$ffi->attach( Delay    => ['uint32'] => 'void'   );
# SDL_GetPerformanceCounter
# SDL_GetPerformanceFrequency
$ffi->attach( GetTicks => [        ] => 'uint32' );
# SDL_RemoveTimer
# SDL_TICKS_PASSED

## Error

$ffi->attach( GetError   => [        ] => 'string' );
$ffi->attach( ClearError => [        ] => 'void'   );
$ffi->attach( SetError   => ['string'] => 'void' => sub { shift->( sprintf shift, @_ ) });

## Render

$ffi->attach( ComposeCustomBlendMode   => [qw( int int int int int int                  )] => 'int'           );
$ffi->attach( CreateRenderer           => [qw( SDL_Window sint32 sint32                 )] => 'SDL_Renderer'  );
$ffi->attach( CreateSoftwareRenderer   => [qw( SDL_Surface                              )] => 'SDL_Renderer'  );
$ffi->attach( CreateTexture            => [qw( SDL_Renderer uint32 sint32 sint32 sint32 )] => 'SDL_Texture'   );
$ffi->attach( CreateTextureFromSurface => [qw( SDL_Renderer SDL_Surface                 )] => 'SDL_Texture'   );
$ffi->attach( CreateWindowAndRenderer  => [qw( int int uint32 opaque* opaque*           )] => 'int'           );
$ffi->attach( DestroyRenderer          => [qw( SDL_Renderer                             )] => 'void'          );
$ffi->attach( DestroyTexture           => [qw( SDL_Texture                              )] => 'void'          );
# SDL_GetNumRenderDrivers
# SDL_GetRenderDrawBlendMode
# SDL_GetRenderDrawColor
# SDL_GetRenderDriverInfo
# SDL_GetRenderer
$ffi->attach( GetRendererInfo     => [qw( SDL_Renderer SDL_RendererInfo    )] => 'int'         );
# SDL_GetRendererOutputSize
$ffi->attach( GetRenderTarget     => [qw( SDL_Renderer                     )] => 'SDL_Texture' );
$ffi->attach( GetTextureAlphaMod  => [qw( SDL_Texture uint8*               )] => 'int'         );
$ffi->attach( GetTextureBlendMode => [qw( SDL_Texture SDL_BlendMode        )] => 'int'         );
$ffi->attach( GetTextureColorMod  => [qw( SDL_Texture uint8* uint8* uint8* )] => 'int'         );
# SDL_GL_BindTexture
# SDL_GL_UnbindTexture
$ffi->attach( LockTexture  => [qw( SDL_Texture SDL_Rect* opaque* int* )] => 'int' );
# SDL_QueryTexture
$ffi->attach( RenderClear  => [qw( SDL_Renderer                                                            )] => 'int' );
$ffi->attach( RenderCopy   => [qw( SDL_Renderer SDL_Texture SDL_Rect* SDL_Rect*                            )] => 'int' );
$ffi->attach( RenderCopyEx => [qw( SDL_Renderer SDL_Texture SDL_Rect* SDL_Rect* double SDL_Rect* SDL_Rect* )] => 'int' );
# SDL_RenderCopyExF
# SDL_RenderCopyF
# SDL_RenderDrawLine
# SDL_RenderDrawLineF
# SDL_RenderDrawLines
# SDL_RenderDrawLinesF
# SDL_RenderDrawPoint
# SDL_RenderDrawPointF
$ffi->attach( RenderDrawPoints => [qw( SDL_Renderer int[] int )] => 'int' );
# SDL_RenderDrawPointsF
$ffi->attach( RenderDrawRect => [qw( SDL_Renderer SDL_Rect* )] => 'int' );
# SDL_RenderDrawRectF
# SDL_RenderDrawRects
# SDL_RenderDrawRectsF
# SDL_Renderer
# SDL_RendererFlags
# SDL_RendererFlip
# SDL_RendererInfo
$ffi->attach( RenderFillRect => [qw( SDL_Renderer SDL_Rect* )] => 'int' );
# SDL_RenderFillRectF
# SDL_RenderFillRects
# SDL_RenderFillRectsF
# SDL_RenderGetClipRect
# SDL_RenderGetIntegerScale
# SDL_RenderGetLogicalSize
# SDL_RenderGetScale
# SDL_RenderGetViewport
# SDL_RenderIsClipEnabled
$ffi->attach( RenderPresent => ['SDL_Renderer'] => 'void' );
# SDL_RenderReadPixels
# SDL_RenderSetClipRect
# SDL_RenderSetIntegerScale
# SDL_RenderSetLogicalSize
# SDL_RenderSetScale
# SDL_RenderSetViewport
# SDL_RenderTargetSupported
# SDL_SetRenderDrawBlendMode
$ffi->attach( SetRenderDrawColor  => [qw( SDL_Renderer uint8 uint8 uint8 uint8 )] => 'int' );
$ffi->attach( SetRenderTarget     => [qw( SDL_Renderer SDL_Texture             )] => 'int' );
$ffi->attach( SetTextureAlphaMod  => [qw( SDL_Texture uint8                    )] => 'int' );
$ffi->attach( SetTextureBlendMode => [qw( SDL_Texture SDL_BlendMode            )] => 'int' );
$ffi->attach( SetTextureColorMod  => [qw( SDL_Texture uint8 uint8 uint8        )] => 'int' );
# SDL_Texture
# SDL_TextureAccess
# SDL_TextureModulate
$ffi->attach( UnlockTexture => ['SDL_Texture'] => 'void' );
# SDL_UpdateTexture
# SDL_UpdateYUVTexture

## Surface

$ffi->attach( UpperBlit => [qw( SDL_Surface SDL_Rect* SDL_Surface SDL_Rect* )] => 'int' );
# SDL_BlitScaled
sub BlitSurface { goto &UpperBlit }
# SDL_ConvertPixels
# SDL_ConvertSurface
# SDL_ConvertSurfaceFormat
# SDL_CreateRGBSurface
$ffi->attach( CreateRGBSurfaceFrom => [qw( opaque int int int int uint32 uint32 uint32 uint32 )] => 'SDL_Surface' );
# SDL_CreateRGBSurfaceWithFormat
# SDL_CreateRGBSurfaceWithFormatFrom
# SDL_FillRect
# SDL_FillRects
$ffi->attach( FreeSurface => ['SDL_Surface'] => 'void' );
# SDL_GetClipRect
# SDL_GetColorKey
# SDL_GetSurfaceAlphaMod
# SDL_GetSurfaceBlendMode
# SDL_GetSurfaceColorMod
$ffi->attach( RWFromFile => [qw( string string )] => 'SDL_RWops'   );
$ffi->attach( LoadBMP_RW => [qw( SDL_RWops int )] => 'SDL_Surface' );
sub LoadBMP { LoadBMP_RW( RWFromFile( +shift, 'rb' ), 1 ) }
# SDL_LockSurface
# SDL_LowerBlit
# SDL_LowerBlitScaled
# SDL_MUSTLOCK
# SDL_SaveBMP
# SDL_SaveBMP_RW
# SDL_SetClipRect
$ffi->attach( SetColorKey => [qw( SDL_Surface int uint32 )] => 'int' );
# SDL_SetSurfaceAlphaMod
# SDL_SetSurfaceBlendMode
# SDL_SetSurfaceColorMod
# SDL_SetSurfacePalette
# SDL_SetSurfaceRLE
# SDL_UnlockSurface

## GameController

# SDL_GameControllerAddMapping
# SDL_GameControllerAddMappingsFromFile
# SDL_GameControllerAddMappingsFromRW
# SDL_GameControllerAxis
# SDL_GameControllerButton
$ffi->attach( GameControllerClose        => ['SDL_GameController'] => 'void'               );
# SDL_GameControllerEventState
# SDL_GameControllerFromInstanceID
# SDL_GameControllerGetAttached
# SDL_GameControllerGetAxis
# SDL_GameControllerGetAxisFromString
# SDL_GameControllerGetBindForAxis
# SDL_GameControllerGetBindForButton
# SDL_GameControllerGetButton
# SDL_GameControllerGetButtonFromString
$ffi->attach( GameControllerGetJoystick  => ['SDL_GameController'] => 'SDL_Joystick'       );
# SDL_GameControllerGetStringForAxis
# SDL_GameControllerGetStringForButton
# SDL_GameControllerMapping
# SDL_GameControllerMappingForGUID
# SDL_GameControllerName
$ffi->attach( GameControllerNameForIndex => ['int'               ] => 'string'             );
$ffi->attach( GameControllerOpen         => ['int'               ] => 'SDL_GameController' );
# SDL_GameControllerUpdate
$ffi->attach( IsGameController           => ['int'               ] => 'bool'               );

## Joystick

# SDL_JoystickClose
# SDL_JoystickCurrentPowerLevel
# SDL_JoystickEventState
# SDL_JoystickFromInstanceID
# SDL_JoystickGetAttached
# SDL_JoystickGetAxis
# SDL_JoystickGetBall
# SDL_JoystickGetButton
# SDL_JoystickGetDeviceGUID
# SDL_JoystickGetGUID
# SDL_JoystickGetGUIDFromString
# SDL_JoystickGetGUIDString
# SDL_JoystickGetHat
$ffi->attach( JoystickInstanceID => ['SDL_Joystick'] => 'SDL_JoystickID' );
# SDL_JoystickName
# SDL_JoystickNameForIndex
# SDL_JoystickNumAxes
# SDL_JoystickNumBalls
# SDL_JoystickNumButtons
# SDL_JoystickNumHats
# SDL_JoystickOpen
# SDL_JoystickPowerLevel
# SDL_JoystickUpdate
# SDL_NumJoysticks

## Events

$ffi->type( '(opaque, opaque)->void', => 'SDL_EventFilter' );

$ffi->attach( AddEventWatch          => [qw( SDL_EventFilter opaque          )] => 'void'        ); # TODO
$ffi->attach( DelEventWatch          => [qw( SDL_EventFilter opaque          )] => 'void'        ); # TODO
$ffi->attach( EventState             => [qw( uint32 int                      )] => 'uint8'       );
$ffi->attach( FilterEvents           => [qw( SDL_EventFilter opaque          )] => 'void'        ); # TODO
$ffi->attach( FlushEvent             => [qw( uint32                          )] => 'void'        );
$ffi->attach( FlushEvents            => [qw( uint32 uint32                   )] => 'void'        );
sub GetEventFilter { ... } # TODO
$ffi->attach( GetNumTouchDevices     => [qw(                                 )] => 'int'         );
$ffi->attach( GetNumTouchFingers     => [qw( SDL_TouchID                     )] => 'int'         );
$ffi->attach( GetTouchDevice         => [qw( int                             )] => 'SDL_TouchID' );
$ffi->attach( GetTouchFinger         => [qw( SDL_TouchID int                 )] => 'SDL_Finger'  );
$ffi->attach( HasEvent               => [qw( uint32                          )] => 'int'         );
$ffi->attach( HasEvents              => [qw( uint32 uint32                   )] => 'int'         );
$ffi->attach( LoadDollarTemplates    => [qw( SDL_TouchID SDL_RWops           )] => 'int'         );
$ffi->attach( PeepEvents             => [qw( SDL_Event int int uint32 uint32 )] => 'int'         );
$ffi->attach( PollEvent              => [qw( SDL_Event                       )] => 'int'         );
$ffi->attach( PumpEvents             => [qw(                                 )] => 'void'        );
$ffi->attach( PushEvent              => [qw( opaque                          )] => 'int'         );
$ffi->attach( RecordGesture          => [qw( SDL_TouchID                     )] => 'int'         );
$ffi->attach( RegisterEvents         => [qw( uint32                          )] => 'int'         );
$ffi->attach( SaveAllDollarTemplates => [qw( SDL_RWops                       )] => 'int'         );
$ffi->attach( SaveDollarTemplate     => [qw( SDL_GestureID SDL_RWops         )] => 'int'         );
$ffi->attach( SetEventFilter         => [qw( SDL_EventFilter opaque          )] => 'void'        ); # TODO
$ffi->attach( WaitEvent              => [qw( SDL_Event                       )] => 'int'         );
$ffi->attach( WaitEventTimeout       => [qw( SDL_Event int                   )] => 'int'         );

# Not implemented in 2.0.8
# $ffi->attach( GetEventState          => [qw( uint32                          )] => 'uint8'       );
# $ffi->attach( QuitRequested          => [qw(                                 )] => 'int'         );

## Version

$ffi->attach( GetRevision       => [             ] => 'string' );
$ffi->attach( GetRevisionNumber => [             ] => 'int'    ); # Deprecated
$ffi->attach( GetVersion        => ['SDL_Version'] => 'void'   );

## Logging

$ffi->attach( Log                => [qw(         string )] => 'void' => sub { $_[0]->(               sprintf $_[1], @_[ 2 .. $#_ ] ) } );
$ffi->attach( LogCritical        => [qw(     int string )] => 'void' => sub { $_[0]->( $_[1],        sprintf $_[2], @_[ 3 .. $#_ ] ) } );
$ffi->attach( LogDebug           => [qw(     int string )] => 'void' => sub { $_[0]->( $_[1],        sprintf $_[2], @_[ 3 .. $#_ ] ) } );
$ffi->attach( LogError           => [qw(     int string )] => 'void' => sub { $_[0]->( $_[1],        sprintf $_[2], @_[ 3 .. $#_ ] ) } );
$ffi->attach( LogInfo            => [qw(     int string )] => 'void' => sub { $_[0]->( $_[1],        sprintf $_[2], @_[ 3 .. $#_ ] ) } );
$ffi->attach( LogVerbose         => [qw(     int string )] => 'void' => sub { $_[0]->( $_[1],        sprintf $_[2], @_[ 3 .. $#_ ] ) } );
$ffi->attach( LogWarn            => [qw(     int string )] => 'void' => sub { $_[0]->( $_[1],        sprintf $_[2], @_[ 3 .. $#_ ] ) } );
$ffi->attach( LogMessage         => [qw( int int string )] => 'void' => sub { $_[0]->( $_[1], $_[2], sprintf $_[3], @_[ 4 .. $#_ ] ) } );
$ffi->attach( LogMessageV        => [qw( int int string )] => 'void' => sub { $_[0]->( $_[1], $_[2], sprintf $_[3], @_[ 4 .. $#_ ] ) } );
$ffi->attach( LogSetPriority     => [qw( int int        )] => 'void' );
$ffi->attach( LogGetPriority     => [qw( int            )] => 'int'  );
$ffi->attach( LogSetAllPriority  => [qw( int            )] => 'void' );
$ffi->attach( LogResetPriorities => [qw(                )] => 'void' );

# TODO
sub LogGetOutputFunction { ... }
sub LogSetOutputFunction { ... }

# Clean helper functions
delete $SDL2::{$_} for qw( enum pixel_format );

1;
