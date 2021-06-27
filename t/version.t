#!/usr/bin/env perl

use Test2::V0;
use SDL2::Raw;

my $fmt = sub { my $v = shift; sprintf '%d.%d.%d', $v->major, $v->minor, $v->patch };

my $version = SDL2::Version->new;
is $version->$fmt, '0.0.0', 'Can create version object';

SDL2::GetVersion($version);
like $version->$fmt, qr/2\.\d+\.\d+/a, 'Version object is populated';

ok SDL2::GetRevision, 'GetRevision';

done_testing;
