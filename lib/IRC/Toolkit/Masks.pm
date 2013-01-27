package IRC::Toolkit::Masks;

use Carp;
use strictures 1;

use Exporter 'import';
our @EXPORT = qw/
  matches_mask
  normalize_mask
  parse_user
/;

use IRC::Toolkit::Case;


sub matches_mask {
  ## Imported from IRC::Utils:
  my ($mask, $nuh, $casemap) = @_;
  confess "Expected a mask, a string to match, and optional casemap"
    unless defined $mask and length $mask
    and    defined $nuh;

  my $quoted = quotemeta uc_irc $mask, $casemap;
  $quoted =~ s/\\\*/[\x01-\xFF]{0,}/g;
  $quoted =~ s/\\\?/[\x01-\xFF]{1,1}/g;

  $nuh = uc_irc $nuh, $casemap;
  $nuh =~ /^$quoted$/ ? 1 : ()
}

sub normalize_mask {
  my ($orig) = @_;
  confess "normalize_mask expected a mask" unless defined $orig;

  ## Inlined with some tweaks from IRC::Utils

  ## **+ --> *
  $orig =~ s/\*{2,}/*/g;

  my @mask;
  my $piece;

  ## Push nick, if we have one, or * if we don't.
  if ( index($orig, '!') == -1 && index($orig, '@') > -1) {
    $piece = $orig;
    push(@mask, '*');
  } else {
    ($mask[0], $piece) = split /!/, $orig, 2;
  }

  ## Split user/host portions and do some clean up.
  $piece        =~ s/!//g if defined $piece;
  @mask[1 .. 2] = split( /@/, $piece, 2) if defined $piece;
  $mask[2]      =~ s/@//g if defined $mask[2];
  for ( 1 .. 2 ) {
    $mask[$_] = '*' unless defined $mask[$_]
  }

  $mask[0] . '!' . $mask[1] . '@' . $mask[2]
}

sub parse_user {
  my ($full) = @_;

  confess "parse_user() called with no arguments"
    unless defined $full;

  my ($nick, $user, $host) = split /[!@]/, $full;

  wantarray ? ($nick, $user, $host) : $nick
}


1;

=pod

=head1 NAME

IRC::Toolkit::Masks - IRC mask-related utilities

=head1 SYNOPSIS

  use IRC::Toolkit::Masks;

  if ( matches_mask($mask, $host, $casemap) ) {
    ...
  }

  my $bmask = normalize_mask( 'somenick' );  # somenick!*@*
  my $bmask = normalize_mask( 'user@host' ); # *!user@host

  my ($nick, $user, $host) = parse_user( $full );
  my $nick = parse_user( $full );

=head1 DESCRIPTION

IRC mask manipulation utilities derived from L<IRC::Utils>.

=head2 matches_mask

Takes an IRC mask, a string to match it against, and an optional IRC casemap
(see L<IRC::Toolkit::Case>).

Returns boolean true if the match applies successfully.

=head2 normalize_mask

Takes an IRC mask and returns the "normalized" version of the mask.

=head2 parse_user

Splits an IRC mask into components.

Returns all available pieces (nickname, username, and host, if applicable) in
list context.

Returns just the nickname in scalar context.

=head1 AUTHOR

Mask-matching and normalization code derived from L<IRC::Utils>, 
copyright Chris Williams

Jon Portnoy L<avenj@cobaltirc.org>

=cut

