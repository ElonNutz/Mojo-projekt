package myproject::Controller::Users;
use Mojo::Base 'Mojolicious::Controller';
use myproject::Model;

use Digest::SHA qw(sha256_hex);

sub create {
  my $self = shift;

  my $username = $self->param('username');
  my $password1 = $self->param('password1');
  my $password2 = $self->param('password2');

  my $err_msg;
  CHECK: {
    unless ( $username && $password1 && $password2) {
        $err_msg = 'Please, fill all fields!';
        last CHECK;
    }

    my $user = myproject::Model::User->select({username => $username})->hash();

    if ( $user->{user_id} ) {
        $err_msg = 'User with such username already exists!';
        last CHECK;
    }
    # ne = not equal
    if ( $password1 ne $password2 ) {
        $err_msg = 'Passwords do not coincide!';
        last CHECK;
    }
  }

    # Show error
    if ($err_msg) {
        $self->flash(
            error        => $err_msg,
            login        => $username,
        )->redirect_to('users_create_form');

        return;
    }

    # Save User


    my $hashedPassword = sha256_hex($password1);

    my %user = (
        username    => $username,
        password => $hashedPassword,
    );

    my $user_id = myproject::Model::User->insert(\%user);

    # Login User
    $self->session(
        user_id => $user_id,
        login   => $username
    )->redirect_to('auths_create_form') if $user_id #TODO ;
}

1;
