package IRC::Toolkit::Case;

use strictures 1;

use Exporter 'import';
our @EXPORT = qw/
  lc_irc
  uc_irc
  eq_irc
/;

sub lc_irc ($;$) {
  my ($string, $casemap) = @_;
  $casemap = lc( $casemap // 'rfc1459' );

  CASE: {
    if ($casemap eq 'strict-rfc1459') {
      $string =~ tr/A-Z[]\\/a-z{}|/;
      last CASE
    }

    if ($casemap eq 'ascii') {
      $string =~ tr/A-Z/a-z/;
      last CASE
    }

    $string =~ tr/A-Z[]\\~/a-z{}|^/
  }

  $string
}

sub uc_irc ($;$) {
  my ($string, $casemap) = @_;
  $casemap = lc( $casemap // 'rfc1459' );

  CASE: {
    if ($casemap eq 'strict-rfc1459') {
      $string =~ tr/a-z{}|/A-Z[]\\/;
      last CASE
    }

    if ($casemap eq 'ascii') {
      $string =~ tr/a-z/A-Z/;
      last CASE
    }

    $string =~ tr/a-z{}|^/A-Z[]\\~/
  }

  $string
}

sub eq_irc ($$;$) {
  my ($first, $second, $casemap) = @_;
  return unless uc_irc($first, $casemap) eq uc_irc($second, $casemap);
  1
}


1;

=pod

=head1 NAME

IRC::Toolkit::Case - IRC case-folding utilities

=head1 SYNOPSIS

  use IRC::Toolkit::Case;

  my $lower = lc_irc( $string, 'rfc1459' );

  my $upper = uc_irc( $string, 'ascii' );

  if (eq_irc($first, $second, 'strict-rfc1459')) {
    ...
  }

=head1 DESCRIPTION

IRC case-folding utilities.

IRC daemons typically announce their casemap in B<ISUPPORT> (via the
B<CASEMAPPING> directive). This should be one of C<rfc1459>,
C<strict-rfc1459>, or C<ascii>:

  'ascii'           a-z      -->  A-Z
  'rfc1459'         a-z{}|^  -->  A-Z[]\~   (default)
  'strict-rfc1459'  a-z{}|   -->  A-Z[]\

=head2 lc_irc

Takes a string and an optional casemap.

Returns the lowercased string.

=head2 uc_irc

Takes a string and an optional casemap.

Returns the uppercased string.

=head2 eq_irc

Takes a pair of strings and an optional casemap.

Returns boolean true if the strings are equal 
(per the rules specified by the given casemap).

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

Inspired by L<IRC::Utils>, copyright Chris Williams

=cut
