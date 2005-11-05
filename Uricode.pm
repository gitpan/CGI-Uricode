package CGI::Uricode;
########################################################################
# Copyright (c) 1999-2005 Masanori HATA. All rights reserved.
# <http://go.to/hata>
########################################################################

#### Pragmas ###########################################################
use 5.008;
use strict;
use warnings;
#### Standard Libraries ################################################
require Exporter;
our @ISA = 'Exporter';
our @EXPORT_OK = qw(
    uri_encode uri_decode
    uri_escape uri_unescape
);

use Carp;
########################################################################

#### Constants #########################################################
our $VERSION = '0.04'; # 2005-11-05 (since 1999)
########################################################################

=head1 NAME

CGI::Uricode - uri-en/decode a data for CGI program.

=head1 SYNOPSIS

 use CGI::Uricode qw(uri_encode uri_decode);
 
 my %input = (
     'name' => 'Masanori HATA',
     'mail' => 'lovewing@dream.big.or.jp',
     'home' => 'http://go.to/hata',
     );
 my $encoded = uri_encode(%input);
 print $encoded;
 
 my %output = uri_decode($encoded);
 print 'name: ', $output{'name'};

=head1 DESCRIPTION

This module provides a set of functions for the data about C<application/x-www-form-urlencoded>.

=head1 FUNCTIONS

=over

=item uri_encode( $name1 => $value1 [, $name2 => $value2, ...] )

Exportable function. With the given $name and $value pairs, this function encode, construct and return a string of paired C<$name=$value> strings those which are joined with `&' characters.

 $encoded = uri_encode(%param);

Though it is expressed virtually input into a hash (%), it is actually input into an arry (@). The Joined C<$name=$value> strings in the output string will appear in the exact order of which they have been given. So you can control the order of the C<$name=$value> strings in the output string.

The C<application/x-www-form-urlencoded> is specified in the HTML 4.01 L<http://www.w3.org/TR/html4/interact/forms.html#h-17.13.4.1>.

With this function, by internally using the C<uri_escape> function, [SPACE] characters will be converted to "%20" strings to escape. This is normal manner in the HTTP "POST" method. To convert [SPACE] characters to "+" characters might occur in HTTP "GET" method to indicate the delimiters of query words, however this fuction won't do.

=cut

sub uri_encode (@) {
    my @attr = @_;
    if (@attr % 2 == 1) {
        croak 'odd: total number of the given attributes must be even number';
    }
    
    my @pair;
    for (my $i = 0; $i < $#attr; $i += 2) {
        my($name, $value) = ($attr[$i], $attr[$i + 1]);
        $name  = uri_escape($name );
        $value = uri_escape($value);
        push @pair, "$name=$value";
    }
    
    return join('&', @pair);
}

=item uri_decode($string)

Exportable function. This function decord and return the name and the value pairs from the given uri-encoded string. You might input them into a hash (%).

 %param = uri_decode($encoded);

=cut

sub uri_decode ($) {
    my $encoded = shift;
    
    my @string = split('&', $encoded);
    my @decoded;
    foreach my $string (@string) {
        $string =~ tr/+/ /;
        my($name, $value) = split('=', $string);
        $name  = uri_unescape($name );
        $value = uri_unescape($value);
        push(@decoded, $name, $value);
    }
    
    return @decoded;
}

=item uri_escape($string)

Exportable function. This function return the uri-escaped string from the given string. The uri-escape is specified in the RFC 2396 L<http://www.ietf.org/rfc/rfc2396.txt> (and it is partially updated by the RFC 2732). The module L<URI::Escape> does the similar function.

=cut

sub uri_escape ($) {
    utf8::encode(my $string = shift);
    
    # build conversion map
    my %hexhex;
    for (my $i = 0; $i <= 255; $i++) {
        $hexhex{chr($i)} = sprintf('%02X', $i);
    }
    
    # my $Reserved = ';/?:@&=+$,[]'; # "[" and "]" have been added in the RFC 2732
    # my $Alphanum = '0-9A-Za-z';
    # my $Mark = q/-_.!~*'()/;
    # my $Unreserved = $Alphanum . $Mark;
    my $Unreserved = q/0-9A-Za-z\-_.!~*'()/;
    
    $string =~ s/([^$Unreserved])/%$hexhex{$1}/og;
    
    return $string;
}

=item uri_unescape($string)

Exportable function. This function return the uri-unescaped string from the given uri-escaped string.  The uri-escape is specified in the RFC 2396 L<http://www.ietf.org/rfc/rfc2396.txt> (and it is partially updated by the RFC 2732). The module L<URI::Escape> does the similar function.

=cut

sub uri_unescape ($) {
    my $string = shift;
    
    # build conversion map
    my %unescaped;
    for (my $i = 0; $i <= 255; $i++) {
        $unescaped{ sprintf('%02X', $i) } = chr($i); # for %HH
        $unescaped{ sprintf('%02x', $i) } = chr($i); # for %hh
    }
    
    $string =~ s/%([0-9A-Fa-f]{2})/$unescaped{$1}/g;
    
    utf8::decode($string);
    return $string;
}

1;
__END__

=back

=head1 SEE ALSO

=over

=item HTML 4.01: L<http://www.w3.org/TR/html4/interact/forms.html#h-17.13.4.1>

=item RFC 2396: L<http://www.ietf.org/rfc/rfc2396.txt> (URI)

=item RFC 2732: L<http://www.ietf.org/rfc/rfc2732.txt> (URI)

=back

=head1 AUTHOR

Masanori HATA L<http://go.to/hata> (Saitama, JAPAN)

=head1 COPYRIGHT

Copyright (c) 1999-2005 Masanori HATA. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

