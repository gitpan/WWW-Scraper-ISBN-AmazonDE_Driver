#!perl -T

use Test::More tests => 6;
use WWW::Scraper::ISBN;

BEGIN {
	use_ok( 'WWW::Scraper::ISBN::AmazonDE_Driver' );
}

my $isbn = '3473580082';
my $scraper = WWW::Scraper::ISBN->new;
   $scraper->drivers("AmazonDE");

my $record = $scraper->search( $isbn );

ok( $record->found );
my $book = $record->book;

is( $book->{title}, 'Die Welle' );
is( $book->{author}, 'Morton Rhue, Hans-Georg Noack' );
is( $book->{publisher}, 'Ravensburger Buchverlag' );
is( $book->{pubdate}, 'Mai 2008' );
