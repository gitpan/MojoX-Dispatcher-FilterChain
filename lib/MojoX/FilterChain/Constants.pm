package MojoX::FilterChain::Constants;

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);

our @EXPORT = qw(NEXT LAST);

use constant NEXT => 0;
use constant LAST => 1;

1;
__END__

=head1 NAME

MojoX::FilterChain::Constants - constants for the intercepting
filter classes

=head1 SYNOPSIS

    use MojoX::FilterChain::Constants;

    sub run {
        my ( $self, $c ) = @_;

        $c->app->routes->dispatch($c);

        return $c->res->code ? LAST : NEXT;
    }

=head1 DESCRIPTION

L<MojoX::FilterChain::Constants> exports B<LAST> and B<NEXT> constants. They are
used by filter to tell filter manager when there is need for interception.

=cut
