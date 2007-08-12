#!perl -T

use Test::More tests => 6;
use WWW::Scraper::ISBN;

BEGIN {
	use_ok( 'WWW::Scraper::ISBN::AmazonDE_Driver' );
}

my $isbn = '0-596-52724-1';
my $scraper = WWW::Scraper::ISBN->new;
   $scraper->drivers("AmazonDE");

my $record = $scraper->search( $isbn );

ok( $record->found );
my $book = $record->book;

is( $book->{title}, 'Mastering Perl (Mastering)' );
is( $book->{author}, 'Brian D. Foy' );
is( $book->{publisher}, 'O\'Reilly Media' );
is( $book->{pubdate}, 'Juli 2007' );