
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Collected IRC utilities",
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
    "Exporter" => 0,
    "Moo" => 1,
    "POE::Filter::IRCv3" => 0,
    "Scalar::Util" => 0,
    "strictures" => 1
  },
  "VERSION" => "0.05",
  "test" => {
    "TESTS" => "t/*.t t/obj/*.t t/util/*.t"
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



