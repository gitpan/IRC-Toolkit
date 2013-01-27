use Test::More;
use strict; use warnings FATAL => 'all';

use_ok( 'IRC::Toolkit::Case' );

is( lc_irc('ABC[]', 'ascii'), 'abc[]', 'ascii lc ok' );
is( uc_irc('abc[]', 'ascii'), 'ABC[]', 'ascii uc ok' );

is( lc_irc('Nick^[Abc]', 'strict-rfc1459'), 'nick^{abc}', 
  'strict-rfc1459 lc ok'
);
is( uc_irc('nick^{abc}', 'strict-rfc1459'), 'NICK^[ABC]',
  'strict-rfc1459 uc ok'
);

is( lc_irc('Nick~[A\bc]'), 'nick^{a|bc}', 'rfc1459 lc ok' );
is( uc_irc('Nick^{a|bc}'), 'NICK~[A\BC]', 'rfc1459 uc ok' );


done_testing;
