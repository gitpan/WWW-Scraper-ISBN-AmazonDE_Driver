
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Search driver for the (DE) Amazon online catalog.\r",
  "AUTHOR" => "Renee Baecker <module\@renee-baecker.de>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "WWW-Scraper-ISBN-AmazonDE_Driver",
  "EXE_FILES" => [],
  "LICENSE" => "artistic_2",
  "NAME" => "WWW::Scraper::ISBN::AmazonDE_Driver",
  "PREREQ_PM" => {
    "Test::CheckManifest" => "1.22",
    "Test::More" => 0,
    "WWW::Mechanize" => "1.20",
    "WWW::Scraper::ISBN" => "0.24",
    "WWW::Scraper::ISBN::Driver" => "0.17",
    "Web::Scraper" => "0.13"
  },
  "VERSION" => "0.25",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



