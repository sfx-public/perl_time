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
use Date::Manip::Delta ();

use Time::Piece ();
use Time::Seconds;

use Panda::Date ();

# Подготовим дату перед циклами проверки
my $tm1 = Time::Moment->from_string('2015-02-18T10:50:31.521345123+10:00');
my $tm2 = Time::Moment->from_string('2015-02-18T10:50:31.521345124+10:00');

my $dt_format = DateTime::Format::Strptime->new( pattern => '%Y-%m-%dT%H:%M:%S.%9N%z', on_error  => 'croak' );
my $dt1 = $dt_format->parse_datetime('2015-02-18T10:50:31.521345123+1000');
my $dt2 = $dt_format->parse_datetime('2015-02-18T10:50:31.521345124+1000');

my $dm = Date::Manip::Date->new;
my $dm_date1 = $dm->new_date;
my $dm_date2 = $dm->new_date;
$dm_date1->parse('2015-02-18T10:50:31.521345123+10:00');
$dm_date2->parse('2015-02-18T10:50:32.521345123+10:00');

my $tp1 = Time::Piece->strptime('2015-02-18T10:50:31+1000', '%Y-%m-%dT%H:%M:%S%z');
my $tp2 = Time::Piece->strptime('2015-02-18T10:50:32+1000', '%Y-%m-%dT%H:%M:%S%z');

my $pd1 = Panda::Date->new('2015-02-18 10:50:31');
my $pd2 = Panda::Date->new('2015-02-18 10:50:32');

# Тесты граничиваем тесты по времени а не по количеству циклов. 5 секунд каждый.
my $count = -5;

say "\nСравнение дат:\n";

cmpthese( $count, {
    'Time::Moment' => sub {
        my $result = $tm1 <=> $tm2;
    },
    'DateTime' => sub {
        my $result = DateTime->compare( $dt1, $dt2 );
    },
    'Date::Manip' => sub {
        my $result = $dm_date1->cmp($dm_date2);
    },
    'Time::Piece' => sub {
        my $result = $tp1 <=> $tp2;
    },
    'Panda::Date' => sub {
        my $result = $pd1 <=> $pd2;
    },
});
