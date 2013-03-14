
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Useful IRC objects and utilities",
  "AUTHOR" => "Jon Portnoy <avenj\@cobaltirc.org>",
  "BUILD_REQUIRES" => {
    "Test::Exception" => 0,
    "Test::More" => "0.88"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "IRC-Toolkit",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "IRC::Toolkit",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Exporter" => 0,
    "List::Objects::WithUtils" => 0,
    "Moo" => 1,
    "POE::Filter::IRCv3" => 0,
    "Role::Tiny" => 0,
    "Scalar::Util" => 0,
    "Storable" => 0,
    "namespace::clean" => 0,
    "overload" => 0,
    "strictures" => 1
  },
  "VERSION" => "0.082000",
  "test" => {
    "TESTS" => "t/*.t t/02_util/*.t t/05_role/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



