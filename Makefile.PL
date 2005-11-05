use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'CGI::Uricode',
    'VERSION_FROM' => 'Uricode.pm',
    'PREREQ_PM'    => {
        'Exporter' => '5.58',
    },
    ($] >= 5.005 ? (
        'ABSTRACT' => 'uri-en/decode a data for CGI program',
        'AUTHOR'   => 'Masanori HATA <lovewing@dream.big.or.jp>',
        ) : ()),
);
