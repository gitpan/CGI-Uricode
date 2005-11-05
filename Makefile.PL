use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'CGI::Uricode',
    'VERSION_FROM' => 'Uricode.pm',
    ($] >= 5.005 ? (
        'ABSTRACT' => 'uri-en/decode a data for CGI program',
        'AUTHOR'   => 'Masanori HATA <http://go.to/hata>',
        ) : ()),
);
