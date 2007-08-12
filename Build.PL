use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WWW::Scraper::ISBN::AmazonDE_Driver',
    license             => 'perl',
    dist_author         => 'Renee Baecker <module@renee-baecker.de>',
    dist_version_from   => 'lib/WWW/Scraper/ISBN/AmazonDE_Driver.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'WWW::Scraper::ISBN::Driver' => 0,
        'WWW::Scraper::ISBN'         => 0,
    },
    add_to_cleanup      => [ 'WWW::Scraper::ISBN::AmazonDE_Driver-*' ],
);

$builder->create_build_script();
