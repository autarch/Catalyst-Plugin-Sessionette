package Catalyst::TraitFor::Request::Sessionette;

use Moose::Role;

use namespace::autoclean;

has session => (
    is      => 'ro',
    isa     => 'Maybe[Object]',
    lazy    => 1,
    builder => '_build_session',
);

has _session_class => (
    is       => 'ro',
    isa      => 'ClassName',
    init_arg => undef,
    lazy     => 1,
    default  => sub { $_[0]->_config()->{session_class} },
);

has _session_id => (
    is        => 'ro',
    isa       => 'Str',
    init_arg  => undef,
    writer    => '_set_session_id',
    predicate => '_has_session_id',
);

has _config => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => undef,
    lazy     => 1,
    default  => sub { $_[0]->_context()->config()->{'Sessionette'} },
);

sub _build_session {
    my $self = shift;

    return unless $self->_has_session_id();

    return $self->_session_class()->new( session_id => $self->_session_id() );
}

around uri => sub {
    my $orig = shift;
    my $self = shift;

    return $self->$orig() unless @_;

    my $new_uri = shift;

    return $self->$orig(@_)
        unless $new_uri->path() =~ m{^ (?: (.*) / )? -/ (.+) $}x;

    my ( $real_path, $session_id ) = ( $1, $2 );

    $new_uri->path($real_path);
    $self->_set_session_id($session_id);

    return $self->$orig($new_uri);
};

1;
