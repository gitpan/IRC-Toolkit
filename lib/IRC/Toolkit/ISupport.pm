package IRC::Toolkit::ISupport;
{
  $IRC::Toolkit::ISupport::VERSION = '0.072000';
}
use 5.10.1;
use Carp 'confess';
use strictures 1;

use Scalar::Util 'blessed';

use IRC::Message::Object 'ircmsg';

use Exporter 'import';
our @EXPORT = 'parse_isupport';

my $parse = +{

  chanlimit => sub {
    my ($val) = @_;
    my @chunks = split /,/, $val;

    my $ref = {};
    for my $chunk (@chunks) {
      my ($prefixed, $num) = split /:/, $chunk;
      my @prefixes = split '', $prefixed;
      for my $pfx (@prefixes) {
        $ref->{$pfx} = $num
      }
    }

    $ref
  },

  chanmodes => sub {
    my ($val) = @_;
    my ($list, $always, $whenset, $bool) = split /,/, $val;
    +{
      list    => [ split '', $list ],
      always  => [ split '', $always ],
      whenset => [ split '', $whenset ],
      bool    => [ split '', $bool ],
    }
  },

  chantypes => sub {
    my ($val) = @_;
    +{  map {; $_ => 1 } split '', $val }
  },

  maxlist => sub {
    my ($val) = @_;
    my @chunks = split /,/, $val;

    my $ref = {};
    for my $chunk (@chunks) {
      my ($modes, $num) = split /:/, $chunk;
      my @splitm = split '', $modes;
      for my $mode (@splitm) {
        $ref->{$mode} = $num
      }
    }

    $ref
  },

  prefix => sub {
    my ($val) = @_;
    my ($modes, $prefixes) = $val =~ /\(([^)]+)\)(.+)/;
    return +{} unless $modes and $prefixes;

    my @modes = split '', $modes;
    my @pfxs  = split '', $prefixes;
    unless (@modes == @pfxs) {
      warn "modes/prefixes do not appear to match: $modes $prefixes";
      return +{}
    }

    my $ref;
    for my $mode (@modes) {
      $ref->{$mode} = shift @pfxs
    }
    $ref
  },

  statusmsg => sub {
    my ($val) = @_;
    +{ map {; $_ => 1 } split '', $val }
  },

};


sub _isupport_hash {
  my ($obj) = @_;
  my %cur;
  confess "No object passed or no params to process"
    unless defined $obj and @{ $obj->params };
  ## First arg should be the target.
  ## Last is 'are supported by ...'
  my %split = map {;
    my ($key, $val) = split /=/, $_, 2;
    ( lc($key), ($val // '0 but true') )
  } @{ $obj->params }[1 .. ($#{ $obj->params } - 1) ];

  unless (keys %split) {
    warn "Appear to have been passed valid IRC, but not an ISUPPORT string";
    return +{}
  }

  for my $param (map {; lc $_ } keys %split) {
    if (defined $parse->{$param}) {
      $cur{$param} = $parse->{$param}->($split{$param})
    } else {
      $cur{$param} = $split{$param} 
    }
  }

  \%cur
}

sub _isupport_hash_to_obj {
  my ($isupport_hash) = @_;
  IRC::Toolkit::ISupport::Obj->new($isupport_hash)
}

sub parse_isupport {
  my @items = map {;
    blessed $_ ? $_ : ircmsg(raw_line => $_)
  } @_;

  confess 
    'Expected a list of raw IRC lines or IRC::Message::Object instances'
    unless @items;

  my %cur;
  ITEM: for my $item (@items) {
    if ($item->isa('IRC::Message::Object')) {
      my $piece = _isupport_hash($item);
      @cur{keys %$piece} = values %$piece;
      next ITEM
    } else {
      confess "expected an IRC::Message::Object but got $item"
    }
  }

  _isupport_hash_to_obj(\%cur);
}


{ package
  IRC::Toolkit::_ISchanmodes;
  use Carp 'confess';
  use strictures 1;

  sub new {
    my ($cls, $self) = @_;
    confess 'Expected a HASH' unless ref $self eq 'HASH';
    bless $self, $cls 
  }

  sub list    { $_[0]->{list} }
  sub always  { $_[0]->{always} }
  sub whenset { $_[0]->{whenset} }
  sub bool    { $_[0]->{bool} }
}

{ package
  IRC::Toolkit::ISupport::Obj;

  use Carp 'confess';
  use strictures 1;
  use Scalar::Util 'blessed';

  sub new {
    my ($cls, $self) = @_;
    confess "Expected a HASH from _isupport_hash"
      unless ref $self eq 'HASH';
    bless $self, $cls
  }

  sub add {
    my ($self, @items) = @_;
    my %cur = %$self;
    for my $item (@items) {
      confess "Expected HASH or ISupport::Obj, got $item"
        unless blessed $item
        or ref $item eq 'HASH';

      @cur{keys %$item} = values %$item;
    }
    (ref $self || $self)->new(\%cur)
  }

  sub chanlimit {
    my ($self, $val) = @_;
    return ($self->{chanlimit} // {}) unless defined $val;
    $self->{chanlimit}->{$val}
  }

  sub chanmodes {
    my ($self) = @_;
    return unless $self->{chanmodes};
    unless (blessed $self->{chanmodes}) {
      $self->{chanmodes} = 
        IRC::Toolkit::_ISchanmodes->new($self->{chanmodes})
    }
    $self->{chanmodes}
  }

  sub chantypes {
    my ($self, $val) = @_;
    return ($self->{chantypes} // {}) unless defined $val;
    $self->{chantypes}->{$val}
  }

  sub maxlist {
    my ($self, $val) = @_;
    return ($self->{maxlist} // {}) unless defined $val;
    $self->{maxlist}->{$val}
  }

  sub prefix {
    my ($self, $val) = @_;
    return ($self->{prefix} // {}) unless defined $val;
    $self->{prefix}->{$val}
  }

  sub statusmsg {
    my ($self, $val) = @_;
    return ($self->{statusmsg} // {}) unless defined $val;
    $self->{statusmsg}->{$val}
  }

  ## Everything else is bool / int / str we can't parse
  our $AUTOLOAD;
  sub AUTOLOAD {
    my ($self, $val) = @_;
    my $subname = (split /::/, $AUTOLOAD)[-1];
    return if index($subname, 'DESTROY') == 0;
    $self->{$subname}
  }

}


1;

=pod

=head1 NAME

IRC::Toolkit::ISupport - IRC ISUPPORT parser

=head1 SYNOPSIS

  use IRC::Toolkit::ISupport;
  my $isupport = parse_isupport(@lines);

  ## Get the MODES= value
  my $maxmodes = $isupport->modes;

  ## Get the PREFIX= char for mode 'o'
  my $prefix_for_o = $isupport->prefix('o');

  ## ... etc ...

=head1 DESCRIPTION

An ISUPPORT (IRC numeric 005) parser that accepts either raw IRC lines or
L<IRC::Message::Object> instances and produces struct-like objects with some
special magic for parsing known ISUPPORT types.

See L<http://www.irc.org/tech_docs/005.html>

=head2 parse_isupport

Takes a list of raw IRC lines or L<IRC::Message::Object> instances and
produces ISupport objects.

Keys not listed here will return their raw value (or '0 but true' for boolean
values).

The following known keys are parsed to provide a nicer interface:

=head3 chanlimit

If passed a channel prefix character, returns the CHANLIMIT= value for that
prefix.

Without any arguments, returns a HASH mapping channel prefixes to their
respective CHANLIMIT= value.

=head3 chanmodes

The four mode sets described by a compliant CHANMODES= declaration are list
modes, modes that always take a parameter, modes that take a parameter only
when they are set, and boolean-type 'flag' modes, respectively:

  CHANMODES=LIST,ALWAYS,WHENSET,BOOL

You can retrieve ARRAYs containing lists of modes belonging to each set:

  my @listmodes = @{ $isupport->chanmodes->list };
  my $always  = $isupport->chanmodes->always;
  my $whenset = $isupport->chanmodes->whenset;
  my $boolean = $isupport->chanmodes->bool;

=head3 chantypes

Without any arguments, returns a HASH whose keys are the allowable channel
prefixes.

If given a channel prefix, returns boolean true if the channel prefix is
allowed per CHANTYPES.

=head3 maxlist

Without any arguments, returns a HASH mapping list-type modes (see
L</chanmodes>) to their respective numeric limit.

If given a list-type mode, returns the limit for that list.

=head3 prefix

Without any arguments, returns a HASH mapping status modes to their respective
prefixes.

If given a status modes, returns the prefix belonging to that mode.

=head3 statusmsg

Without any arguments, returns a HASH whose keys are the valid message target 
status prefixes.

If given a status prefix, returns boolean true if the prefix is listed in
STATUSMSG.

=head1 MISSING

... typically because I'm not sure if there's authoritative documentation or
where it might be found ...

=over

=item *

ELIST

=item *

EXTBAN

=item *

TARGMAX

=back

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
