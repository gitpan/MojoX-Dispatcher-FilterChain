#!perl

use strict;
use warnings;

use Test::More tests => 11;

use_ok('MojoX::FilterChain::DetectLang');

use Mojo::Transaction;
use MojoX::Dispatcher::FilterChain;
use MojoX::Dispatcher::FilterChain::Context;

my $c = MojoX::Dispatcher::FilterChain::Context->new();

my $chain = MojoX::Dispatcher::FilterChain->new();

$chain->add(MojoX::FilterChain::DetectLang->new(languages => [qw/ en de /]));

# no language specified
$c->tx(Mojo::Transaction->new_get('http://example.com'));
$chain->process($c);
ok(not defined $c->stash->{language});
is($c->tx->req->url, 'http://example.com');

# no language
$c->tx(Mojo::Transaction->new_get('http://example.com/stuff'));
$chain->process($c);
ok(not defined $c->stash->{language});
is($c->tx->req->url, 'http://example.com/stuff');

# language
$c->tx(Mojo::Transaction->new_get('http://example.com/de'));
$chain->process($c);
is($c->stash->{language}, 'de');
is($c->tx->req->url, 'http://example.com/');

# language with slash
$c->tx(Mojo::Transaction->new_get('http://example.com/de/'));
$chain->process($c);
is($c->stash->{language}, 'de');
is($c->tx->req->url, 'http://example.com/');

# language followed by path
$c->tx(Mojo::Transaction->new_get('http://example.com/de/stuff'));
$chain->process($c);
is($c->stash->{language}, 'de');
is($c->tx->req->url, 'http://example.com/stuff');
