use Test::More;
use strict; use warnings FATAL => 'all';

use_ok( 'IRC::Toolkit::Colors' );

my $str;
ok( $str = color('bold', "A string"), 'color() ok' );
cmp_ok( $str, 'eq', "\x02A string\x0f", 'bold string ok' );

cmp_ok( color('bold', "Start bold") ." end normal",
  'eq',
  "\x02Start bold\x0f end normal",
  'bold interpolated ok'
);

done_testing;
