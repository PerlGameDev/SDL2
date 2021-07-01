# SDL2

This is a work-in-progress set of bindings for SDL2 using [FFI::Platypus].

The immdiate goal is to implement bindings for a sufficiently complete
subset of SDL2 that is as close as possible to the original to serve as
the building blocks for any syntactic sugar that we might want to build
on top.

This is still early in development. The names of the modules and the
distribution itself are placeholders for now.

Until more documentation is written, the examples directory holds samples
of how this library can be used.

Some of the tests make use of a spritesheet made available in the `share`
directory. That spritesheet is the [Dungeon Tileset II] by 0x72.

[Dungeon Tileset II]: https://0x72.itch.io/dungeontileset-ii
[FFI::Platypus]: https://metacpan.org/pod/FFI::Platypus
