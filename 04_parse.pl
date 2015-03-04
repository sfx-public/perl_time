#!/usr/bin/env perl

use Modern::Perl '2015';
use Data::Dumper;
use Benchmark qw( cmpthese );

use Time::Local;
use Time::HiRes;

use Time::Moment ();

use DateTime ();
use DateTime::Format::ISO8601 ();
use DateTime::Format::Strptime ();

use Date::Manip ();
use Date::Manip::Date ();

use Time::Piece ();
use Time::Seconds;

use Panda::Date ();

# Подготовка
my $dm = Date::Manip::Date->new;
my $iso8601 = '2015-02-18T10:50:31.521345123+10:00';
my $td_parser = DateTime::Format::Strptime->new( pattern => '%Y-%m-%dT%H:%M:%S.%9N%z', on_error  => 'croak' );

# Тесты граничиваем тесты по времени а не по количеству циклов. 5 секунд каждый.
my $count = -5;

say "\nПарсинг строки:\n";

cmpthese( $count, {
    'Time::Moment' => sub {
        my $tm = Time::Moment->from_string($iso8601);
    },
    'DateTime (ISO8601)' => sub {
        my $td = DateTime::Format::ISO8601->parse_datetime($iso8601);
    },
    'DateTime (Strptime)' => sub {
        my $td = $td_parser->parse_datetime('2015-02-18T10:50:31.521345123+1000');
    },
    'Date::Manip' => sub {
        my $date = $dm->new_date;
        $date->parse($iso8601);
    },
    'Time::Piece' => sub {
        my $tp = Time::Piece->strptime('2015-02-18T10:50:31+1000', '%Y-%m-%dT%H:%M:%S%z');
    },
    'Panda::Date' => sub {
        my $pd = Panda::Date->new('2015-02-18 10:50:31');
    },
});
