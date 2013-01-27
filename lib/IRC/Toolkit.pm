package IRC::Toolkit;
our $VERSION = '0.01';

use Carp;
use strictures 1;

my @modules = qw/
  Case
  Colors
  CTCP
  Masks
  Modes
  Parser
/;

sub import {
  my $self = shift;
  my $pkg = caller;
  my @failed;
  for my $mod (@modules) {
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

IRC::Toolkit - Collected IRC utilities

=head1 SYNOPSIS

  ## Import all of the included Tookit:: modules:
  use IRC::Toolkit;

=head1 DESCRIPTION

A collection of useful IRC-related utilities. See their respective
documentation, below.

L<IRC::Message::Object>; objects representing incoming or outgoing IRC events

L<IRC::Toolkit::Case>; RFC-compliant case folding tools

L<IRC::Toolkit::Colors>; Color/format interpolation in strings

L<IRC::Toolkit::CTCP>; CTCP quoting and extraction tools

L<IRC::Toolkit::Masks>; Hostmask parsing and matching tools

L<IRC::Toolkit::Modes>; Mode-line parsing tools

L<IRC::Toolkit::Parser>; Functional interface to L<POE::Filter::IRCv3>

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Portions of code are derived from L<IRC::Utils>, L<Net::IRC>, and
L<POE::Filter::IRC::Compat>, which are copyright their respective authors;
these items are documented where they are found, as well.

Licensed under the same terms as Perl.

=cut

