package Catalyst::Plugin::Sessionette;

use Moose::Role;

use namespace::autoclean;

use Catalyst::TraitFor::Request::Sessionette;
use Catalyst::TraitFor::Response::Sessionette;
use CatalystX::RoleApplicator ();

after setup_finalize => sub {
    my $app = shift;

    # yeah, i know. sue me.
    CatalystX::RoleApplicator->init_meta( for_class => $app );

    $app->apply_request_class_roles(
        'Catalyst::TraitFor::Request::Sessionette');
    $app->apply_response_class_roles(
        'Catalyst::TraitFor::Response::Sessionette');
};

after setup => sub {
    my $self = shift;

    my $config = $self->config()->{'Sessionette'} || {};

    die
        'You must provide an session_class in the session config when using Catalyst::Plugin::Sessionette'
        . __PACKAGE__
        unless defined $config->{session_class};
};

1;
