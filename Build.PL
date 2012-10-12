#!perl -w

use strict;
use warnings;
use Carp;

use Module::Build;
# See perldoc Module::Build for details of how this works
### Subsystems to build
#    <subsystem>
#        <file> = hash of the following 2 values:
#            <from> = location of source file
#            <to>   = location of build file to get name right
#        <libraries> = list reqiured libraries, names the same as keys to hash %libraries
my %subsystems = (
	SDL2 => {
		file => {
			from => 'src/SDL2.xs',
			to   => 'lib/SDL2.xs',
		},
		libraries => [qw( SDL2 )],
        }
    );


### External libraries
#    <library name> = symbolic library name
#        <define> = value that will be used as -D<value> option when compiling XS code
#        <header> = header related to the library that will be used for avalability detection,
#                   could be a sigle value or an array of values
#        <lib>    = value that will be used as -l<value> option when linking XS code
my %libraries = (
	SDL => {
		define => 'HAVE_SDL2',
		header => 'SDL2/SDL.h',
		lib    => 'SDL2',
	}
   );
### Mangle the compilable files into a format Module::Build can understand
my %xs =
	map { $subsystems{$_}{file}{from} => $subsystems{$_}{file}{to} }
	keys %subsystems;

my $build = Module::Build->new(
        module_name     => 'SDL2',
        license         => 'perl',
        dist_version_from  => 'lib/SDL2.pm',
        dist_abstract   => 'XS bindings to libSDL2',
        configure_requires => {
        'Module::Build'      => '0',
        'ExtUtils::CBuilder' => '0.260301',
        'Alien::SDL'         => '1.438',
        'File::Find'         => '0',
        'File::ShareDir'     => '1.0',
        'Tie::Simple'        => '0',
        'Capture::Tiny'      => '0',
        },
        build_requires => {
        'Test::Simple'   => '0.88',
        'Capture::Tiny'  => '0',
        'Test::Most'     => '0.21',
        'Alien::SDL'     => '1.438',
        'File::Find'     => '0',
        'File::ShareDir' => '1.0',
        'Tie::Simple'    => '0',
        'Scalar::Util'   => '0',
        },
        requires => {
            'Scalar::Util'   => '0',
            'Tie::Simple'    => '0',
            'File::ShareDir' => '1.0',
            'CPAN'           => '1.92',
            'perl'           => '5.008000',
        },
	    'xs_files'      => \%xs,
        'extra_compiler_flags' =>   '-I/usr/local/include -Isrc',
        'extra_linker_flags' => '-lSDL2'
        
        );
print "Detecting available libraries ...\n";

#my $build_systems = $build->find_subsystems( \%subsystems, \%libraries );

  $build->create_build_script;
