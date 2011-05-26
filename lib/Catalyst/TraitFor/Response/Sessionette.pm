package Catalyst::TraitFor::Request::Sessionette;

use Moose::Role;

use namespace::autoclean;

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
