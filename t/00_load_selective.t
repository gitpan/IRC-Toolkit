use Test::More;
use strict; use warnings FATAL => 'all';

BEGIN { 
  use_ok( 'IRC::Toolkit', qw/Masks Modes/ )
}
can_ok( 'main', $_ ) for 
  ## Masks
  qw/ matches_mask normalize_mask parse_user /,
  ## Modes
  qw/ mode_to_array mode_to_hash /,
;
done_testing;
