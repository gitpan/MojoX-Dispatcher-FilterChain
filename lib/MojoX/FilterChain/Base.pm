package MojoX::FilterChain::Base;

use strict;
use warnings;

use base 'Mojo::Base';

require Carp;

sub run { Carp::croak('Run method is not implemented') }

1;
__END__

=head1 NAME

MojoX::FilterChain::Base - Base class for intercepting filter

=head1 SYNOPSIS

    package MyApp::FilterChain::Routes;

    use strict;
    use warnings;

    use base 'MojoX::FilterChain::Base';

    use MojoX::FilterChain::Constants;

    sub run {
        my ( $self, $c ) = @_;

        $c->app->routes->dispatch($c);

        return $c->res->code ? LAST : NEXT;
    }

    1;

=head1 DESCRIPTION

L<MojoX::FilterChain::Base> is a base class for intercepting filter 

=head1 METHODS

L<MojoX::FilterChain::Base> inherits all methods from L<Mojo::Base> and
implements the following the ones.

=head2 C<run>

    Method that is called during chain process.

=cut
