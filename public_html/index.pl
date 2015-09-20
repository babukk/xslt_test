#! /usr/bin/perl -w
#--------------------------------------------

use strict;
use CGI qw(:standard);
use HTML::Template;

use constant  XSLT_DIR    => '/var/www/fastcgi/xslt_tmpl';
use constant  TMPL_DIR    => '/var/www/fastcgi/tmpl';
use constant  PERLLIB_DIR => '/var/www/fastcgi/lib';
use constant  SECRET_KEY  => '324891234896178263876';
use constant  SECRET_USER => 'vasya';

my $mycgi = new CGI;

my $token = $mycgi->param( 'token' );
my $header;


unless ($token) {
    use WWW::CSRF qw(generate_csrf_token check_csrf_token CSRF_OK);

    $header = header( -TYPE=>'text/html', -EXPIRES=>"-1d", -CHARSET=>"UTF-8", );
    print $header;


    my $tmpl_path = TMPL_DIR;
    my $template = HTML::Template->new( filename=>$tmpl_path . '/index.tmpl', die_on_bad_params=>0 );

    my $csrf_token = generate_csrf_token( SECRET_USER, SECRET_KEY );

    my @file_list = ();
    opendir( DIR, XSLT_DIR );
    while (my $file = readdir( DIR )) {
        my %row = ();
        next if ($file =~ m/^\./);
        $row{ FILENAME } = $file;
        push( @file_list, \%row );
    }


    $template->param(
        TOKEN => $csrf_token,
        XSLT_FILES => \@file_list,
    );

    print $template->output;
}
else {
    use lib PERLLIB_DIR;
    use XML::LibXML;
    use XSLTTemplate;
    use Data::Dumper;

    $header = header( -TYPE=>'text/html', -EXPIRES=>"-1d", -CHARSET=>"UTF-8", );
    print $header;

    my $status = check_csrf_token( SECRET_USER, SECRET_KEY, $token );
    die "Wrong CSRF token" unless ($status == CSRF_OK);


    my $xml_dom = XML::LibXML::Document->new( '1.0', 'utf-8' );

    my $root = $xml_dom->createElement( "xmlroot" );
    my $doc = $xml_dom->createElement( "document" );
    $root->appendChild( $doc );
    my %tags = (
        username => $mycgi->param( 'username' ),
        email => $mycgi->param( 'email' ),
    );

    for my $name (keys %tags) {
        my $tag = $xml_dom->createElement( $name );
        my $value = $tags{ $name };
        $tag->appendTextNode( $value );
        $doc->appendChild( $tag );
    }

    $xml_dom->setDocumentElement( $root );

    my $xslt_tmpl = new XSLTTemplate( xslt_file => XSLT_DIR . '/' . $mycgi->param( 'xslt_file' ), );

    $xslt_tmpl->setData( $xml_dom );

    print $xslt_tmpl->parse();
}
