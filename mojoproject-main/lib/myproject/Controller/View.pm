package myproject::Controller::View;
use Mojo::Base 'Mojolicious::Controller';
use strict;
use warnings;
use myproject::Model;

sub user {
    my $self = shift;

    #my $passedParam = $self->param('user');
    $self->render('view/user');
    
}


sub dealership {
    my $self = shift;

    $self->render('view/dealership');
    
}


sub car {
    my $self = shift;

    $self->render('view/car');
    
}

1;