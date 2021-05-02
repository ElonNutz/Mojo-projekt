package myproject::Controller::Auths;
use Mojo::Base 'Mojolicious::Controller';
use myproject::Model;

use Digest::SHA qw(sha256_hex);


sub create {
    my ($self) = @_;

    my $username    = $self->param('username');
    my $password = $self->param('password');
    $password = sha256_hex($password);

    my $user = myproject::Model::User->select({username => $username, password=>$password})->hash();

    if ( $username  && $user->{user_id} ) {
        $self->session(
            user_id => $user->{user_id},
            username   => $user->{username}
        )->redirect_to('main_home');
    }
    else {
        $self->flash( error => 'Wrong password or user does not exist!' )->redirect_to('auths_create_form');
    }
}

sub delete {
    shift->session( user_id => '', username => '' )->redirect_to('auths_create_form');
}

sub check {
    shift->session('user_id') ? 1 : 0;
}

1;
