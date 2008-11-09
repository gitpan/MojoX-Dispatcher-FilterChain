use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'MojoX::Dispatcher::FilterChain',
    AUTHOR              => 'Viacheslav Tikhanovskii <vti@cpan.org>',
    VERSION_FROM        => 'lib/MojoX/Dispatcher/FilterChain.pm',
    ABSTRACT_FROM       => 'lib/MojoX/Dispatcher/FilterChain.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Mojo'       => 0,
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MojoX-Dispatcher-FilterChain-*' },
);
