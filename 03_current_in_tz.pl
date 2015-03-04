#!/usr/bin/env perl

use Modern::Perl '2015';
use Data::Dumper;
use Benchmark qw( cmpthese );

use Time::Local;
use Time::HiRes;

use Time::Moment ();

use DateTime ();

use Date::Manip ();
use Date::Manip::Date ();

use Time::Piece ();
use Time::Seconds;

use Panda::Date ();

# Подготовка
my $dm = Date::Manip::Date->new;

# Тесты граничиваем тесты по времени а не по количеству циклов. 5 секунд каждый.
my $count = -5;

say "\nСоздание объектов в заданной временной зоне (UTC+10):\n";

cmpthese( $count, {
    'Time::Moment' => sub {
        my $tm = Time::Moment->now_utc;
        my $tm_with_offset = $tm->with_offset_same_instant(600); # тут смещение в минутах
    },
    'DateTime' => sub {
        my $dt = DateTime->now( time_zone => '+1000' );
    },
    'Date::Manip' => sub {
        my $date = $dm->new_date;
        $date->parse('now gtm+10');
    },
    'Time::Piece' => sub {
        my $tp = Time::Piece->gmtime;
        $tp += 60*60*10; # тут смещение в секундах
    },
    'Panda::Date' => sub {
        my $pd = Panda::Date->new( time, 'UTC' );
        $pd->to_tz('UTC-10');
    },
});
