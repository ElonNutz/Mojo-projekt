package Avtohisa;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config');

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('MojController#displayLogin');
  $r->post('/login')->to('MojController#validUserCheck');
  $r->any('/logout')->to('MojController#logout');



  my $authorized = $r->under ('/')->to('MojController#alreadyLoggedIn');
}

1;
