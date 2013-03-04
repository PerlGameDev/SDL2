#!perl -w

use strict;
use warnings;

use Alien::SDL2;
use Module::Build;

### All available subsystems to build
my %mods = (
    'SDL2pp' => {
        xs => [ 'src/SDL2pp.xs' => 'lib/SDL2pp.xs'],
        libs => [qw( SDL2 )],
    },
    'SDL2::Window' => {
        xs => [ 'src/Core/objects/Window.xs' => 'lib/SDL2/Window.xs' ],
        libs => [qw( SDL2 )],
    },
    'SDL2::Renderer' => {
        xs => [ 'src/Core/objects/Renderer.xs' => 'lib/SDL2/Renderer.xs' ],
        libs => [qw( SDL2 )],
    },
    'SDL2::Rect' => {
        xs => [ 'src/Core/objects/Rect.xs' => 'lib/SDL2/Rect.xs' ],
        libs => [qw( SDL2 )],
    }
);

### Check for available libs
for my $m (keys %mods) {
  my @libs = @{$mods{$m}{libs}};
  if (!Alien::SDL2->havelib(@libs)) {
    warn "WARNING: disabling '$m' (requires: " . join(',',@libs) . ")\n";
    delete $mods{$m} ;
  }
}

### Prepare data we later pass to Module::Build
my %xs      = map { $mods{$_}{xs}[0] => $mods{$_}{xs}[1] } keys %mods;
my %mod2lib = map { $_ => $mods{$_}{libs} } keys %mods;
my $cflags  = '-I. -Isrc '. Alien::SDL2->config('cflags');
my $libs    = Alien::SDL2->config('libs');

my $build = Module::Build->new(
    module_name     => 'SDL2',
    license         => 'perl',
    dist_version_from  => 'lib/SDL2.pm',
    dist_abstract   => 'XS bindings to libSDL2',
    configure_requires => {
        'Module::Build'      => '0',
        'ExtUtils::CBuilder' => '0.260301',
        'Alien::SDL2'        => '0',
        'File::Find'         => '0',
        'File::ShareDir'     => '1.0',
        'Tie::Simple'        => '0',
        'Capture::Tiny'      => '0',
    },
    build_requires => {
        'Test::Simple'       => '0.88',
        'Capture::Tiny'      => '0',
        'Test::Most'         => '0.21',
        'Alien::SDL2'        => '0',
        'File::Find'         => '0',
        'File::ShareDir'     => '1.0',
        'Tie::Simple'        => '0',
        'Scalar::Util'       => '0',
    },
    requires => {
        'Scalar::Util'       => '0',
        'Tie::Simple'        => '0',
        'File::ShareDir'     => '1.0',
        'CPAN'               => '1.92',
        'perl'               => '5.008000',
    },
    create_readme => 1,
    xs_files => \%xs,
    extra_compiler_flags =>  $cflags,
    extra_linker_flags => $libs,
    config_data => { mod2lib => \%mod2lib },
);

$build->create_build_script;
