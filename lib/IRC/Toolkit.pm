package IRC::Toolkit;
{
  $IRC::Toolkit::VERSION = '0.084000';
}

use Carp;
use strictures 1;

## Core bits can be added to this list ...
## ... but removing modules will break stuff downstream
my @modules = qw/
  Case
  Colors
  CTCP
  ISupport
  Masks
  Modes
  Parser
/;

sub import {
  my ($self, @load) = @_;
  @load = @modules unless @load;
  my $pkg = caller;
  my @failed;
  for my $mod (@load) {
    my $c = "package $pkg; use IRC::Toolkit::$mod";
    eval $c;
    if ($@) {
      warn $@;
      push @failed, $mod
    }
  }
  confess "Failed to import ".join ' ', @failed if @failed;
  1
}

1;


=pod

=head1 NAME

IRC::Toolkit - Useful IRC objects and utilities

=head1 SYNOPSIS

  ## Import the most commonly used Tookit:: modules
  ##  (Case, Colors, CTCP, ISupport, Masks, Modes, Parser)
  use IRC::Toolkit;

  ## Import specific modules:
  use IRC::Toolkit qw/
    CTCP
    Masks
    Modes
    Numerics
  /;

=head1 DESCRIPTION

A collection of useful IRC-related utilities. See their respective
documentation, below.

L<IRC::Message::Object>; objects representing incoming or outgoing IRC events

L<IRC::Mode::Single>; objects representing a single mode change

L<IRC::Mode::Set>; objects representing a set of mode changes

L<IRC::Toolkit::Case>; RFC-compliant case folding tools

L<IRC::Toolkit::Colors>; Color/format interpolation in strings

L<IRC::Toolkit::CTCP>; CTCP quoting and extraction tools

L<IRC::Toolkit::ISupport>; ISUPPORT (numeric 005) parser

L<IRC::Toolkit::Masks>; Hostmask parsing and matching tools

L<IRC::Toolkit::Modes>; Mode-line parsing tools

L<IRC::Toolkit::Numerics>; IRC numerics translation to/from RPL or ERR names

L<IRC::Toolkit::Parser>; Functional interface to L<POE::Filter::IRCv3>

L<IRC::Toolkit::TS6>; Produce TS6 IDs

L<IRC::Toolkit::Role::CaseMap>; A Role for classes that track IRC casemapping
settings

=head1 SEE ALSO

L<IRC::Utils>

L<Parse::IRC>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Portions of code are derived from L<IRC::Utils>, L<Net::IRC>, and
L<POE::Filter::IRC::Compat>, which are copyright their respective authors;
these items are documented where they are found.

Licensed under the same terms as Perl.

=cut

