package myproject::Controller::Main;
use Mojo::Base 'Mojolicious::Controller';
use myproject::Model;

# This action will render a template
sub home {
  my $self = shift;

  $self->render('home');
}

sub profile {
  my $self = shift;

  $self->render('profile');
}

sub dealerships {
  my $self = shift;

  $self->render('dealerships');
}
sub cars {
  my $self = shift;

  $self->render('cars');
}

1;
