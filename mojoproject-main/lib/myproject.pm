package myproject;
use Mojo::Base 'Mojolicious';
use myproject::Model;


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
  $r->get('/')->to(controller => 'main', action => 'home')->name('main_home');
  $r->get('/dealerships')->to(controller => 'main', action => 'dealerships')->name('main_dealerships');
  $r->get('/cars')->to(controller => 'main', action => 'cars')->name('main_cars');
  $r->get('/profile')->to(controller => 'main', action => 'profile')->name('main_profile');

  $r->get('/user/:user')->to(controller=>'view', action=>'user')->name('view_user');
  $r->get('/dealership/:dealership')->to(controller=>'view', action=>'dealership')->name('view_dealership');
  $r->get('/car/:car')->to(controller=>'view', action=>'car')->name('view_car');


  $r->post('/login')->to(controller => 'auths', action => 'create')->name('auths_create');
  $r->get('/login')->to(controller => 'auths', action => 'create_form')->name('auths_create_form');
  
  
  $r->get('/logout')->to(controller => 'auths', action => 'delete')->name('auths_delete');
  
  $r->get('/signup')->to(controller => 'users', action => 'create_form')->name('users_create_form');
  $r->post('/signup')->to(controller => 'users', action => 'create')->name('users_create');
  

  #connect to database
  myproject::Model->init($config->{db} ||{
    dsn => "DBI:SQLite:dbname=database.db",
    user => "",
    password => ""
  });
}

1;
