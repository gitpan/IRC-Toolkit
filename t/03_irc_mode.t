use Test::More;
use strict; use warnings FATAL => 'all';

use_ok( 'IRC::Mode::Single' );

my $mode = new_ok( 'IRC::Mode::Single' =>
  [ '+', 'o', 'avenj' ]
);
cmp_ok( $mode->flag, 'eq', '+' );
cmp_ok( $mode->char, 'eq', 'o' );
cmp_ok( $mode->param, 'eq', 'avenj' );
cmp_ok( $mode->as_string, 'eq', '+o avenj' );
cmp_ok( "$mode", 'eq', '+o avenj' );

done_testing;
