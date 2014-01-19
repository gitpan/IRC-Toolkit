
use strict;
use warnings;

use 5.008009;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Useful IRC objects and utilities",
  "AUTHOR" => "Jon Portnoy <avenj\@cobaltirc.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "IRC-Toolkit",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "IRC::Toolkit",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Exporter::Tiny" => 0,
    "List::Objects::Types" => 1,
    "List::Objects::WithUtils" => 2,
    "Moo" => 1,
    "MooX::late" => "0.014",
    "POE::Filter::IRCv3" => "0.045",
    "Role::Tiny" => 0,
    "Scalar::Util" => 0,
    "Storable" => 0,
    "Sub::Infix" => 0,
    "Types::Standard" => 0,
    "namespace::clean" => 0,
    "overload" => 0,
    "strictures" => 1
  },
  "TEST_REQUIRES" => {
    "Test::Exception" => 0,
    "Test::More" => "0.88"
  },
  "VERSION" => "0.088001",
  "test" => {
    "TESTS" => "t/*.t t/02_util/*.t t/05_role/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Exporter::Tiny" => 0,
  "List::Objects::Types" => 1,
  "List::Objects::WithUtils" => 2,
  "Moo" => 1,
  "MooX::late" => "0.014",
  "POE::Filter::IRCv3" => "0.045",
  "Role::Tiny" => 0,
  "Scalar::Util" => 0,
  "Storable" => 0,
  "Sub::Infix" => 0,
  "Test::Exception" => 0,
  "Test::More" => "0.88",
  "Types::Standard" => 0,
  "namespace::clean" => 0,
  "overload" => 0,
  "strictures" => 1
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



