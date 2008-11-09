#!perl

use strict;
use warnings;

use Test::More tests => 4;

use_ok('MojoX::Dispatcher::FilterChain');
use_ok('MojoX::Dispatcher::FilterChain::Context');

my $c = MojoX::Dispatcher::FilterChain::Context->new();

my $chain = MojoX::Dispatcher::FilterChain->new();

$chain->add(FilterFirst->new());
$chain->add(FilterIntercept->new());
$chain->add(FilterLast->new());

$chain->process($c);

is($c->stash->{foo}, 'bar');
ok(not defined $c->stash->{last});

1;

package FilterFirst;
use base 'MojoX::FilterChain::Base';
use MojoX::FilterChain::Constants;

sub run {
    my ($self, $c) = @_;
    $c->stash->{foo} = 'bar';
    return NEXT;
}
1;

package FilterIntercept;
use base 'MojoX::FilterChain::Base';
use MojoX::FilterChain::Constants;

sub run {
    return LAST;
}
1;

package FilterLast;
use base 'MojoX::FilterChain::Base';
use MojoX::FilterChain::Constants;

sub run {
    my ($self, $c) = @_;
    $c->stash->{last} = 1;
    return LAST;
}
1;
