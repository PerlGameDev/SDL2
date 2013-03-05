use strict;
use warnings;
use Test::More;
use SDL2::ConfigData;

BEGIN {
  plan skip_all => 'SDL2::Rect not available' unless SDL2::ConfigData->config('mod2lib')->{'SDL2::Rect'};
}

use SDL2::Rect;

ok( exists &SDL2::Rect::new, 'new exists');

can_ok('SDL2::Rect', qw/new/);

my $rect = SDL2::Rect->new(0,0,0,0);

isa_ok($rect, 'SDL2::Rect', 'new makes an SDL2::Rect');

ok 1, 'success 1';
ok 1, 'success 2';

done_testing();
