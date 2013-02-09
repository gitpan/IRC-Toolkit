use Test::More;
use strict; use warnings FATAL => 'all';

use_ok( 'IRC::Toolkit::Masks' );

## parse_user
is(
  my $nick = parse_user('SomeNick!user@my.host.org'),
  'SomeNick',
  'parse_user (scalar) ok'
);

is_deeply(
  [ parse_user('SomeNick!user@my.host.org') ],
  [ 'SomeNick', 'user', 'my.host.org' ],
  'parse_user (list) ok'
);


## normalize_mask
cmp_ok( normalize_mask('avenj'), 'eq', 'avenj!*@*',
  'normalize_mask (nick-only) ok'
);
cmp_ok( normalize_mask('*@*'), 'eq', '*!*@*',
  'normalize_mask (wildcard) ok'
);
cmp_ok( normalize_mask('*avenj@*'), 'eq', '*!*avenj@*',
  'normalize_mask (partial) ok'
);


## matches_mask
ok( matches_mask('*!*@*', 'avenj!avenj@oppresses.us'),
  'matches_mask( *!*@* ) ok'
);
ok( matches_mask('*!avenj@oppresses.us', 'avenj!avenj@oppresses.us'),
  'matches_mask( *!avenj@oppresses.us ) ok'
);
ok( !matches_mask('nobody!nowhere@*', 'avenj!avenj@oppresses.us'),
  'negative matches_mask ok'
);


done_testing;
