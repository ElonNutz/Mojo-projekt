package myproject::Model;
use strict;
use warnings;
use DBIx::Simple;
use SQL::Abstract;
use Carp qw/croak/;


use Digest::SHA qw(sha256_hex);

use myproject::Model::User;
use myproject::Model::Session;
use myproject::Model::Dealership;
use myproject::Model::Car;



my $DB;

sub init 
{
    my ($self, $config) = @_;

    croak "No dsn was passed!" unless $config && $config->{dsn};
    
    $DB = DBIx::Simple->connect(@$config{qw/dsn user password/}, { RaiseError => 1 }) or die DBIx::Simple->error;

    $DB->abstract = SQL::Abstract->new(
        case          => 'lower',
        logic         => 'and',
        convert       => 'upper'
    );

    $self->create_database();

    

    return $DB;

}

sub db {
    return $DB if $DB;
    croak "You should init model first!";
}

sub create_database {
    my $self = shift;

    my $stmnt;
    my $rv;

    unless ( eval{$DB->select('users')}) 
    {
        print "Missing table users. Creating...\n";
        $stmnt = qq(CREATE TABLE IF NOT EXISTS users(           
        user_id INTEGER NOT NULL PRIMARY KEY ASC AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,

        is_staff INTEGER DEFAULT '0',

        created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ););
        $rv = $DB->query($stmnt); #run statement
        
        my $rootPassword = "veryhardpassword";
        $rootPassword = sha256_hex($rootPassword);
        $stmnt = qq(INSERT OR IGNORE INTO users(username, password, is_staff) VALUES('root', '$rootPassword','1'););
        $rv = $DB->query($stmnt);
        
        print "Created.\n";

        

    }
    
    unless ( eval{$DB->select('dealerships')}) 
    {
        print "Missing table dealerships. Creating...\n";
        $stmnt = qq(CREATE TABLE IF NOT EXISTS dealerships(     
        dealership_id INTEGER NOT NULL PRIMARY KEY ASC AUTOINCREMENT,
        user_id INTEGER NOT NULL 
        CONSTRAINT fk_user_id
        REFERENCES users(user_id)
        ON DELETE CASCADE,
        name TEXT NOT NULL UNIQUE,
        address TEXT NOT NULL,
        post_number INTEGER NOT NULL,
        created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ););
        $rv = $DB->query($stmnt);
        print "Created.\n";

    }
    
    unless ( eval{$DB->select('brands')}) 
    {
        print "Missing table brands. Creating...\n";
        $stmnt = qq(CREATE TABLE IF NOT EXISTS brands(     
        brand_id INTEGER NOT NULL PRIMARY KEY ASC AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
        ););
        $rv = $DB->query($stmnt);  

        $stmnt = qq(INSERT OR IGNORE INTO brands(name) VALUES ('Hundai'),('Subaru'),('Audi'),('Mercedes'),('BMW'),('Volkswagen'););
        $rv = $DB->query($stmnt);

        print "Created.\n";

    }
     
    unless ( eval{$DB->select('fuels')}) 
    {
        print "Missing table fuels. Creating...\n";
        $stmnt = qq(CREATE TABLE IF NOT EXISTS fuels(     
        fuel_id INTEGER NOT NULL PRIMARY KEY ASC AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
        ););
        $rv = $DB->query($stmnt);

        $stmnt = qq(INSERT OR IGNORE INTO fuels(name) VALUES ('Electric'),('Diesel'),('Gasoline'););
        $rv = $DB->query($stmnt);

        print "Created.\n";

    }
    
    unless ( eval{$DB->select('cars')}) 
    {
        print "Missing table cars. Creating...\n";
        $stmnt = qq(CREATE TABLE IF NOT EXISTS cars(     
        car_id INTEGER NOT NULL PRIMARY KEY ASC AUTOINCREMENT,
        
        dealership_id INTEGER NOT NULL 
        CONSTRAINT fk_dealership_id
        REFERENCES dealerships(dealership_id)
        ON DELETE CASCADE,
        
        brand_id INTEGER NOT NULL
        CONSTRAINT fk_brand_id
        REFERENCES brands(brand_id)
        ON DELETE CASCADE,
        
        fuel_id INTEGER NOT NULL
        CONSTRAINT fk_fuel_id
        REFERENCES fuels(fuel_id)
        ON DELETE CASCADE,
        
        name TEXT NOT NULL,

        kilometers INTEGER NOT NULL,
        year INTEGER NOT NULL,
        price REAL NOT NULL,
        created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ););
        $rv = $DB->query($stmnt);
        print "Created.\n";
    }
    
    unless ( eval{$DB->select('sessions')}) 
    {
        print "Missing table sessions. Creating...\n";
        $stmnt = qq(CREATE TABLE IF NOT EXISTS sessions(     
        session_id INTEGER NOT NULL PRIMARY KEY ASC AUTOINCREMENT,
        
        user_id INTEGER NOT NULL 
        CONSTRAINT fk_user_id
        REFERENCES users(user_id)
        ON DELETE CASCADE,

        session_key TEXT NOT NULL,

        expires_on TIMESTAMP NOT NULL,
        created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ););
        $rv = $DB->query($stmnt);
        print "Created.\n";
    }

    
    
    
    

}


1;