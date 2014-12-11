package Mojo::IOLoop::Resolver;

use Mojo::Base -base;

has reactor => sub { Mojo::IOLoop->singleton->reactor };

sub getaddrinfo {
  my ($self, $address, $port, $cb) = @_;

  # $self, $err, $addr_info
  $self->reactor->next_tick(sub { $self->cb(undef, undef) });
}


1;

