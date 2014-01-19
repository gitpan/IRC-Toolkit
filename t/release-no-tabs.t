
BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}

use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::NoTabsTests 0.05

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/IRC/Message/Object.pm',
    'lib/IRC/Mode/Set.pm',
    'lib/IRC/Mode/Single.pm',
    'lib/IRC/Toolkit.pm',
    'lib/IRC/Toolkit/CTCP.pm',
    'lib/IRC/Toolkit/Case.pm',
    'lib/IRC/Toolkit/Case/MappedString.pm',
    'lib/IRC/Toolkit/Colors.pm',
    'lib/IRC/Toolkit/ISupport.pm',
    'lib/IRC/Toolkit/Masks.pm',
    'lib/IRC/Toolkit/Modes.pm',
    'lib/IRC/Toolkit/Numerics.pm',
    'lib/IRC/Toolkit/Parser.pm',
    'lib/IRC/Toolkit/Role/CaseMap.pm',
    'lib/IRC/Toolkit/TS6.pm'
);

notabs_ok($_) foreach @files;
done_testing;
