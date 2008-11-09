#!perl

use strict;
use warnings;

use Test::More tests => 1;

use_ok('MojoX::Dispatcher::FilterChain');

my $c = 0;

my $chain = MojoX::Dispatcher::FilterChain->new();

$chain->add(Filter1->new());
$chain->add(Filter2->new());
$chain->process($c);

1;

package Filter1;
use base 'MojoX::FilterChain::Base';
use MojoX::FilterChain::Constants;

sub run {
    return NEXT;
}
1;

package Filter2;
use base 'MojoX::FilterChain::Base';
use MojoX::FilterChain::Constants;

sub run {
    return LAST;
}
1;
