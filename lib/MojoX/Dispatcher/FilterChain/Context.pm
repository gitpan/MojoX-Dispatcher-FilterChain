package MojoX::Dispatcher::FilterChain::Context;

use strict;
use warnings;

use base 'Mojo::Base';

__PACKAGE__->attr('tx', default => sub { Mojo::Transaction->new });
__PACKAGE__->attr('stash', default => sub { {} });

1;
__END__

=head1 NAME

MojoX::Dispatcher::FilterChain::Context - FilterChain dispatcher context

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

L<MojoX::Dispatcher::FilterChain::Context> inherits all methods from
L<Mojo::Base> and implements the following ones.

=head2 C<tx>

    Mojo::Transaction object.

=head2 C<stash>

    Stash where filters can put data.

=head1 COPYRIGHT & LICENSE

Copyright 2008 Viacheslav Tikhanovskii, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
