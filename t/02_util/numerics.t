use Test::More;
use strict; use warnings FATAL => 'all';

BEGIN {
  use_ok( 'IRC::Toolkit::Numerics' );
}

ok( main->can('name_from_numeric'), 'name_from_numeric imported' );
ok( main->can('numeric_from_name'), 'numeric_from_name imported' );

my $name = name_from_numeric('005');
cmp_ok( $name, 'eq', 'RPL_ISUPPORT', 'name_from_numeric() ok' );

my $num = numeric_from_name('RPL_LUSEROP');
cmp_ok( $num, 'eq', '252', 'numeric_from_name() ok' );

my $numshash  = IRC::Toolkit::Numerics->export;
my $nameshash = IRC::Toolkit::Numerics->export_by_name;
cmp_ok( $numshash->keys->count, '==', $nameshash->keys->count, 
  'exported hashes have same key count'
) or do {
  my %seen;
  for my $name ($numshash->values->all) {
    if ($seen{$name}) {
      diag "DUPE: $name\n"
    }
    $seen{$name}++
  }
  BAIL_OUT("Failed")
};

done_testing;
