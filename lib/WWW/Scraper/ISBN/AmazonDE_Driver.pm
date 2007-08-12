package WWW::Scraper::ISBN::AmazonDE_Driver;

use warnings;
use strict;

use base qw(WWW::Scraper::ISBN::Driver);
use WWW::Mechanize;

use constant    AMAZON => 'http://www.amazon.de/';
use constant    SEARCH => 'http://www.amazon.de/';


=head1 NAME

WWW::Scraper::ISBN::AmazonDE_Driver - Search driver for the (DE) Amazon online
catalog.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

See parent class documentation (L<WWW::Scraper::ISBN::Driver>)

=head1 DESCRIPTION

Searches for book information from the (DE) Amazon online catalog.
This module is a mere paste and translation of L<WWW::Scraper::ISBN::AmazonFR_Driver>.

=head1 FUNCTIONS

=head2 search

=cut

sub search {
    my ($self,$isbn) = @_;
    
    $self->found(0);
    $self->book(undef);

    my $mechanize = WWW::Mechanize->new();
    $mechanize->get( SEARCH );
    return    $self->handler('Error loading amazon.de form web page (unreachable?)')
        unless($mechanize->success());

    my ($index,$input) = (0,0);

    $mechanize->form_name('site-search')
        or return $self->handler('Error parsing amazon.de form');

    my $keyword ='search-alias=stripbooks';
    $mechanize->set_fields( 
                'field-keywords' => $isbn, 
                'url'            => $keyword 
                );
    $mechanize->submit();

    return    $self->handler('Error about form submission (form changed?)') 
        unless($mechanize->success());

    my $content=$mechanize->content();
    my ($con,$thumb, $image, $pub);

    if(
       $content =~ s{
           .*
       <meta \s  name="description"  \s content=" ( [^"]* ) "     .*
           <div  \s class="buying">                                   .*
           <script \s language=                                       .*
           function \s registerImage 
                         }{}msx
           )
    {$con=$1;}

    if($content =~ s{

     <script>                                            .*
     registerImage\("original_image",
           \s " ( [^"]* )  ",

                          }{}msx )
    {$thumb=$1;}

    if($content =~ m{
     <li><b>Verlag:</b>\s*(.*?)</li>
                }msx)
    {$pub=$1;}

    if($content =~ s{
                \s "<a \s href="\+'"'\+" ( [^"]* ) "\+          .*
                <b \s class="h1">Produktbeschreibungen</b><br\s /> 
    }{}msx )
    {$image=$1};

    my $data = {};
    $data->{content}    = $con;
    $data->{thumb_link} = $thumb;
    $data->{image_link} = $image;
    $data->{published}  = $pub;

    return $self->handler("Could not extract data from amazon.de result page.")
        unless(defined $data);

    # trim top and tail
    foreach (keys %$data) { 
        next unless defined $data->{$_};
        $data->{$_} =~ s/^\s+//;
        $data->{$_} =~ s/\s+$//;
    }

    ($data->{title},$data->{author}) = 
        ($data->{content} =~ 
                  /Amazon.de\s*:\s*
                  (.*)
                  :\s*(?:(?:English\sBooks?)|B�cher|B&amp;uuml;cher).*
                  by\s+(.*)/x);


    ($data->{publisher},$data->{pubdate}) = 
        ($data->{published} =~ /\s*(.*?)(?:;.*?)?\s+\(([^)]*)/);

    my $bk = {
        'isbn'        => $isbn,
        'author'      => $data->{author},
        'title'       => $data->{title},
        'image_link'  => $data->{image_link},
        'thumb_link'  => $data->{thumb_link},
        'publisher'   => $data->{publisher},
        'pubdate'     => $data->{pubdate},
        'book_link'   => $mechanize->uri()
    };
    $self->book($bk);
    $self->found(1);
    return $self->book;
}

=head1 AUTHOR

Renee Baecker, C<< <module at renee-baecker.de> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-www-scraper-isbn-amazonde_driver at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW::Scraper::ISBN::AmazonDE_Driver>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Scraper::ISBN::AmazonDE_Driver

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW::Scraper::ISBN::AmazonDE_Driver>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW::Scraper::ISBN::AmazonDE_Driver>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW::Scraper::ISBN::AmazonDE_Driver>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW::Scraper::ISBN::AmazonDE_Driver>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Renee Baecker, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of WWW::Scraper::ISBN::AmazonDE_Driver