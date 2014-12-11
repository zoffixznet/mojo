package Mojo::IOLoop::Resolver::NetDNSNative;

use Mojo::Base 'Mojo::IOLoop::Resolver';

use Socket qw(IPPROTO_TCP);
has ndn => sub { Net::DNS::Native->new(pool => 5, extra_thread => 1) };

sub getaddrinfo {
  my ($self, $address, $port, $cb) = @_;

  my $NDN = $self->ndn;

  my $handle = $self->{dns}
    = $NDN->getaddrinfo($address, $port, {protocol => IPPROTO_TCP});

  $self->reactor->io(
    $handle => sub {
      my $reactor = shift;

      $reactor->remove($self->{dns});
      my ($err, @res) = $NDN->get_result(delete $self->{dns});

      $self->$cb($err, \@res);
    }
  )->watch($handle, 1, 0);
}

1;

