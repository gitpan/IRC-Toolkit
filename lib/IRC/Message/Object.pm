package IRC::Message::Object;

use strictures 1;
use Carp;
use Moo;

use POE::Filter::IRCv3;

use Exporter 'import';
our @EXPORT_OK = 'ircmsg';

sub ircmsg {
  __PACKAGE__->new(@_)
}

sub truncate {
  ...
  ## FIXME truncate raw_line to 512 *with* \r\n
  ##  but *not* including message tags
  ##  (and trailing space after them)
  ##  per http://ircv3.atheme.org/specification/message-tags-3.2
  ## return new Event
}

has 'command' => (
  required  => 1,
  is        => 'ro',
  predicate => 'has_command',
  writer    => 'set_command',
);

has 'prefix' => (
  is        => 'ro',
  lazy      => 1,
  predicate => 'has_prefix',
  writer    => 'set_prefix',
  default   => sub { '' },
);

has 'params' => (
  is        => 'ro',
  lazy      => 1,
  isa       => sub {
    ref $_[0] eq 'ARRAY' 
    or confess "'params =>' not an ARRAY: $_[0]"
  },
  predicate => 'has_params',
  writer    => 'set_params',
  default   => sub { [] },
);

has 'raw_line' => (
  is        => 'ro',
  lazy      => 1,
  predicate => 'has_raw_line',
  writer    => 'set_raw_line',
  default   => sub {
    my ($self) = @_;
    my %hash;
    for my $key (qw/prefix command params tags/) {
      my $pred = "has_".$key;
      $hash{$key} = $self->$key if $self->$pred;
    }
    my $lines = $self->__filter->put( [ \%hash ] );
    $lines->[0]
  },
);

has 'tags' => (
  is        => 'ro',
  lazy      => 1,
  isa       => sub {
    ref $_[0] eq 'HASH'
    or confess "'tags =>' not a HASH: $_[0]"
  },
  predicate => 'has_tags',
  writer    => 'set_tags',
  default   => sub {  {}  },
);

sub BUILDARGS {
  my $class = shift;
  my %params = @_ > 1 ? @_ : (raw_line => $_[0]) ;

  if (not defined $params{command}) {
    if (defined $params{raw_line}) {
      ## Try to create self from raw_line instead:
      my $filt = $class->__build_filter;
      my $refs = $filt->get( [$params{raw_line}] );
      %params = %{ $refs->[0] } if @$refs;
    } else {
      confess "Bad params; a command or a raw_line must be specified in new()"
    }
  }

  \%params
}

sub get_tag {
  my ($self, $tag) = @_;
  return unless $self->has_tags and keys %{ $self->tags };
  ## A tag might have an undef value ...
  ## ... see has_tag
  $self->tags->{$tag}
}

sub has_tag {
  my ($self, $tag) = @_;
  return unless $self->has_tags and keys %{ $self->tags };
  exists $self->tags->{$tag}
}

sub tags_as_array {
  my ($self) = @_;
  return [] unless $self->has_tags and keys %{ $self->tags };

  my $tag_array = [];
  while (my ($thistag, $thisval) = each %{ $self->tags }) {
    push @$tag_array,
      defined $thisval ? join '=', $thistag, $thisval
        : $thistag
  }

  $tag_array
}

sub tags_as_string {
  my ($self) = @_;
  return unless $self->has_tags and keys %{ $self->tags };

  my $str;
  my @tags = %{ $self->tags };
  while (my ($thistag, $thisval) = splice @tags, 0, 2) {
    $str .= ( $thistag . 
      ( defined $thisval ? '='.$thisval : '' ) .
      ( @tags ? ';' : '' )
    );
  }

  $str
}


has '__filter' => (
  is       => 'rw',
  init_arg => 'filter',
  lazy     => 1,
  builder  => '__build_filter',
);

sub __build_filter {
  my ($self) = @_;
  POE::Filter::IRCv3->new(colonify => 1)
}

no warnings 'void';
q{
 <rnowak> fine, be rude like that
 <Perihelion> SORRY I WAS DISCUSSING THE ABILITY TO PUT
  AN IRCD ON A ROOMBA
};

=pod

=head1 NAME

IRC::Message::Object - Incoming or outgoing IRC events

=head1 SYNOPSIS

  ## Feed me some parameters:
  my $event = IRC::Message::Object->new(
    command  => '001',
    prefix   => ':some.server.org',
    params   => [ 'user', 'Welcome to IRC' ],
  );

  ## ... or import and use the 'ircmsg()' shortcut:
  use IRC::Message::Object 'ircmsg';
  my $event = ircmsg(
    command => '001',
    prefix  => ':some.server.org',
    params  => [ 'user', 'Welcome to IRC' ],
  );

  ## ... or take a raw IRC line (and parse it):
  my $event = ircmsg(
    raw_line => ':some.server.org 001 user :Welcome to IRC'
  );

  ## ... or feed from POE::Filter::IRCD or POE::Filter::IRCv3:
  my $event = ircmsg( %$ref_from_filter );

  ## ... retrieve useful bits later (see Methods):
  my $cmd  = $event->command;
  my $line = $event->raw_line;
  if ($event->has_tag('monkeys')) {
    ...
  }

=head1 DESCRIPTION

These objects represent incoming or outgoing IRC messages (events); they can
be created from either named parameters or a raw IRC line and provide
accessors with automatic parsing magic.

=head2 Functions

=head3 ircmsg

Create a new B<IRC::Message::Object>

Shortcut for C<< IRC::Message::Object->new >>

=head2 Methods

=head3 command

The parsed command received. (No case-folding takes place.)

predicate: C<has_command>

=head3 params

ARRAY of parameters.

predicate: C<has_command>

=head3 prefix

The origin prefix.

predicate: C<has_prefix>

=head3 raw_line

The raw IRC line. This will be generated via L<POE::Filter::IRCv3> if we
weren't constructed with one.

predicate: C<has_raw_line>

=head3 get_tag

Retrieve a specific tag.

This only works for tags with a defined value; see L</has_tag> to discover if
a tag exists.

=head3 has_tag

Takes a tag identifier; returns true if the tag exists.

This is useful for finding out about tags that have no defined value.

=head3 tags

IRCv3.2 message tags, as a HASH of key-value pairs.

=head3 tags_as_array

IRCv3.2 message tags, as an ARRAY of tags in the form of 'key=value'

=head3 tags_as_string

IRCv3.2 message tags as a specification-compliant string.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
