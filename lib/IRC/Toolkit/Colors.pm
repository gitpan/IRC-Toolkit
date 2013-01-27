package IRC::Toolkit::Colors;

use Carp;
use strictures 1;

use Exporter 'import';
our @EXPORT = 'color';

our %COLORS = (
  NORMAL      => "\x0f",

  BOLD        => "\x02",
  UNDERLINE   => "\x1f",
  REVERSE     => "\x16",
  ITALIC      => "\x1d",

  WHITE       => "\x0300",
  BLACK       => "\x0301",
  BLUE        => "\x0302",
  GREEN       => "\x0303",
  RED         => "\x0304",
  BROWN       => "\x0305",
  PURPLE      => "\x0306",
  ORANGE      => "\x0307",
  YELLOW      => "\x0308",
  TEAL        => "\x0310",
  PINK        => "\x0313",
  GREY        => "\x0314",
  GRAY        => "\x0314",

  LIGHT_BLUE  => "\x0312",
  LIGHT_CYAN  => "\x0311",
  LIGHT_GREEN => "\x0309",
  LIGHT_GRAY  => "\x0315",
  LIGHT_GREY  => "\x0315",
);

sub color {
  my ($fmt, $str) = @_;
  $fmt = uc($fmt || 'normal');
  my $slct = $COLORS{$fmt};
  unless (defined $slct) {
    carp "Invalid format $fmt passed to color()";
    return $str || $COLORS{NORMAL}
  }
  return $slct . $str . $COLORS{NORMAL} if $str;
  return $slct
}

1;

=pod

=head1 NAME

IRC::Toolkit::Colors - IRC color code utilities

=head1 SYNOPSIS

  my $str = color('red', "red text") ." other text";

=head1 DESCRIPTION

IRC utilities for adding color/formatting codes to a string.

=head2 color

  my $code = color('red');
  my $str = color('bold') . "bold text" . color() . "normal text";
  my $str = color('bold', "bold text");

Add mIRC formatting/color codes to a string.

Valid formatting codes are:

  normal 
  bold 
  underline 
  reverse 
  italic

Valid color codes are:

  white
  black
  blue
  light_blue
  light_cyan
  green
  light_green
  red
  brown
  purple
  orange
  yellow
  teal
  pink
  gray
  light_gray

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
