package XSLTTemplate;

use strict;
use XML::LibXSLT;
# use Data::Dumper;

# ------------------------------------------------------

sub new
{
    my $class = shift;
    my %params = @_;

    my $self = {
        xslt_file => $params{ 'xslt_file' },
    };

    my $xslt = XML::LibXSLT->new;
    eval  {
        $self->{ stylesheet } = $xslt->parse_stylesheet_file( $self->{ xslt_file } );
    };

    return bless $self, $class;
}


# ------------------------------------------------------

sub parse
{
    my $self = shift;

    my $result = '';
    eval  {
        $result =  $self->{ stylesheet }->transform( $self->{ xml } );
    };

    return $result;
}


# ------------------------------------------------------

sub setData
{
    my ($self, $xml) = @_;

    $self->{ xml } = $xml;

    return;
}

1;
