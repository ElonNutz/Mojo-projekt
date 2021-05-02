package myproject::Model::Base;
use strict;
use warnings;
use base qw/Mojo::Base/;


sub select {
    my $class = shift;
 
    myproject::Model->db->select($class->table_name, '*', @_);
}

sub insert {
    my $class = shift;
    my $db = myproject::Model->db;
    $db->insert($class->table_name, @_)   or die $db->error();
}

sub update {
    my $class = shift;
    my $db = myproject::Model->db;
    $db->update($class->table_name, @_) or die $db->error();
}

sub delete {
    my $class = shift;
    my $db = myproject::Model->db;
    $db->delete($class->table_name, @_) or die $db->error();
}

1;

__END__