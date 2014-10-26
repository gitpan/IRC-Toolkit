use Test::More;
use strict; use warnings FATAL => 'all';

use_ok( 'IRC::Toolkit::Modes' );

is_deeply(
  mode_to_array( '+kl-t',
    params => [ 'key', 10 ],
    param_always => [ split //, 'bkov' ],
    param_set    => [ 'l' ],
  ),
  [
    [ '+', 'k', 'key' ],
    [ '+', 'l', 10 ],
    [ '-', 't' ],
  ],
  'mode_to_array chan modes ok'
);
my $array = mode_to_array( '+o-o+vb avenj avenj Joah things@stuff' );
is_deeply( $array,
  [
    [ '+', 'o', 'avenj' ],
    [ '-', 'o', 'avenj' ],
    [ '+', 'v', 'Joah'  ],
    [ '+', 'b', 'things@stuff' ],
  ],
  'mode_to_array status modes ok'
) or diag explain $array;



my $mhash;
ok( $mhash = mode_to_hash(  '+ot-k+l',
    params => [ qw/SomeUser thiskey 10/ ],
  ), 'mode_to_hash() (default param_ opts)'
);

is_deeply( $mhash,
  {
    add => {
      'o' =>
        [ 'SomeUser' ],
      't' => 1,
      'l' =>
        [ 10 ],
    },
    del => {
      'k' => [ 'thiskey' ],
    },
  },
  'mode_to_hash looks ok'
);

ok( $mhash = mode_to_hash(  '+h',
    params => [ 'SomeUser' ],
    param_always => [ 'h' ],
  ), 'mode_to_hash() (custom param_always)'
);

is_deeply( $mhash,
  {
    add => {
      'h' => [ 'SomeUser' ],
    },
    del => { },
  },
  'mode_to_hash (param_always) looks ok'
);

done_testing;
