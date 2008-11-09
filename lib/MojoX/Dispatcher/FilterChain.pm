package MojoX::Dispatcher::FilterChain;

use strict;
use warnings;

use base 'Mojo::Base';

use MojoX::Dispatcher::FilterChain::Constants;

our $VERSION = '0.02';

use constant DEBUG => $ENV{MOJOX_DISPATCHER_FILTERCHAIN_DEBUG} || 0;

__PACKAGE__->attr('filters', default => sub { [] });

sub add {
    my $self   = shift;
    my $filter = shift;

    my $name = ref $filter;
    warn "Adding filter '$name'" if DEBUG;

    push @{$self->filters}, $filter;
}

sub process {
    my $self = shift;

    foreach my $filter (@{$self->filters}) {
        my $name = ref $filter;

        warn "Running '$name' filter" if DEBUG;

        my $proceed = $filter->run(@_);

        warn "Stop filter chain after '$name' filter"
          if DEBUG and $proceed == LAST;

        last if $proceed == LAST;
    }
}

1;
__END__

=head1 NAME

MojoX::Dispatcher::FilterChain - Intercepting filter manager

=head1 SYNOPSIS

    use MojoX::Dispatcher::FilterChain;

    my $chain = MojoX::Dispatcher::FilterChain->new();
    $chain->add(LanguageDetect->new);
    $chain->add(Authorization->new);
    $chain->add(RenderView->new);

    ...

    $chain->process($c);

=head1 DESCRIPTION

L<MojoX::Dispatcher::FilterChain> is a intercepting filter manager pattern
implementation. 

Standart dispatch process can look like this:

    sub dispatch {
        my ($self, $c) = @_;

        # Try to find a static file
        $self->static->dispatch($c);

        # Use routes if we don't have a response code yet
        $self->routes->dispatch($c) unless $c->res->code;

        # Nothing found, serve static file "public/404.html"
        unless ($c->res->code) {
           #$self->static->serve($c, '/404.html');
           #$c->res->code(404);
        }
    }

Problem is that we have repetitive code that is checking whether to go to the
next dispatcher or stop. 

What we want to have is a list of independent filters that are called in
specific order and one of them can intercept the chain.

Now we can rewrite our dispatch example.

    __PACKAGE__->attr('chain', 
        default => sub { MojoX::Dispatcher::FilterChain->new } );

    sub dispatch {
        my ($self, $c) = @_;

        # run filter chain
        $self->chain->process($c);
    }

    sub startup {
        my $self = shift;

        my $chain = $self->chain;

        $chain->add(MyApp::FilterChain::StaticDispatch->new($c));
        $chain->add(MyApp::FilterChain::RoutesDispatch->new($c));
        $chain->add(MyApp::FilterChain::RenderView->new($c));
    }

Filter itself inherits L<MojoX::FilterChain::Base> and has method B<run> that
is called when chain is processed. L<MojoX::FilterChain::Constants>
module exports two self explaining constants B<NEXT> and B<LAST>. Depending on
which value is returned after running current filter, chain proceeds or stops.

Regular filter can look like this:

    package MyApp::FilterChain::Routes;

    use strict;
    use warnings;

    use base 'MojoX::FilterChain::Base';

    # export LAST and NEXT constants
    use MojoX::FilterChain::Constants;

    sub run {
        my ( $self, $c ) = @_;

        $c->app->routes->dispatch($c);

        return $c->res->code ? LAST : NEXT;
    }

    1;

=head1 METHODS

L<MojoX::Dispatcher::FilterChain> inherits all methods from L<Mojo::Base> and
implements the following the ones.

=head2 C<new>

    my $chain = MojoX::Dispatcher::FilterChain->new;

=head2 C<add>

    Add filter instance to filter chain.

    my $chain->add(Filter->new);

=head2 C<process>

    Run filter chain. Parameters provided will be passed on to every filter.

    $chain->process($c);


=head1 COPYRIGHT & LICENSE

Copyright 2008 Viacheslav Tikhanovskii, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
