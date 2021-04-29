package Avtohisa::Controller::MojController;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  #$self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
  $self->render(template => 'myTemplates/homepage', msg => 'Dobrodosli');
}

sub displayLogin {

my $self = shift;
if(&alreadyLoggedIn($self)){

&welcome($self);


}
else {
    $self->render (template=>"myTemplates/login", napaka => "Za uporabo se morate prijaviti");
}

}

sub validUserCheck {
    my $self = shift;

    my %validUsers = ( "Jane" => "Kebab123",
    "Jill" => "kebab123"
    );
    my $user = $self->param('username');
    my $password = $self->param('password');
if($validUsers{$user}){
    if($validUsers{$user} eq $password){
        $self->session(is_auth => 1);
        $self->session(username => $user);
        $self->session(expiration => 1000);
         

        &welcome($self);
    
    }else{ $self ->render (template => "myTemplates/login", napaka => "Napacno geslo");
    }   
    }else {
        $self->render(template => "myTemplates/login", napaka => "Uporabnik ne obstaja");
    }


}


sub alreadyLoggedIn{
    my $self = shift;

    return 1 if $self->session('is_auth');  

    $self->render(template => "myTemplates/login", napaka => "Za uporabo se morate prijaviti");
    return;
}

sub logout{

    my $self = shift;
    $self -> session (expires => 1);
    $self -> render (template => "myTemplates/logout");
}

1;
