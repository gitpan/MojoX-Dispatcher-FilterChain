package MojoX::FilterChain::DetectLang;

use strict;
use warnings;

use base 'MojoX::FilterChain::Base';

use MojoX::FilterChain::Constants;

__PACKAGE__->attr('languages', default => sub {[]});
__PACKAGE__->attr('stash_key', default => 'language');

sub run {
    my $self = shift;
    my ( $c ) = @_;

    if (my $path = $c->tx->req->url->path) {
        my $part = $path->parts->[ 0 ];

        if ( $part && grep { $part eq $_ } @{ $self->languages } ) {

            shift @{ $path->parts };

            $c->stash->{ $self->stash_key } = $part;
        }
    }

    return NEXT;
}

1;
__END__

=head1 NAME

MojoX::FilterChain::DetectLang - Detect client language filter

=head1 SYNOPSIS

    $chain
      ->add(MojoX::FilterChain::DetectLang->new(languages => [qw/ en de /]));

    ...

    # /
    $chain->process($c);
    $c->stash->{language}; # undef

    # /en
    $chain->process($c);
    $c->stash->{language}; # en

    # /de/path
    $chain->process($c);
    $c->stash->{language}; # de

=head1 DESCRIPTION

L<MojoX::FilterChain::DetectLang> is a filter for detecting client language

=head1 METHODS

L<MojoX::FilterChain::DetectLang> inherits all methods from
L<MojoX::FilterChain::Base> and implements the following ones.

=head2 C<languages>

    Languages that your website can handle.

=head2 C<stash_key>

    Stash variable name where language will be stored.

=cut
