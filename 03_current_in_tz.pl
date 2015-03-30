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

use Date::Calc ();

# Подготовка
my $dm = Date::Manip::Date->new;
my @dc_tz = (0, 10, 0, 0); # Обозначение временной зоны UTC+10 в виде дельты DHMS

# Тесты граничиваем тесты по времени а не по количеству циклов. 5 секунд каждый.
my $count = -5;

say "\nСоздание объектов в заданной временной зоне (UTC+10):\n";

cmpthese( $count, {
    'T::M' => sub {
        my $tm = Time::Moment->now_utc;
        my $tm_with_offset = $tm->with_offset_same_instant(600); # тут смещение в минутах
    },
    'DT' => sub {
        my $dt = DateTime->now( time_zone => '+1000' );
    },
    'D::M' => sub {
        my $date = $dm->new_date;
        $date->parse('now gtm+10');
    },
    'T::P' => sub {
        my $tp = Time::Piece->gmtime;
        $tp += 60*60*10; # тут смещение в секундах
    },
    'P::D' => sub {
        my $pd = Panda::Date->new( time, 'UTC' );
        $pd->to_tz('UTC-10');
    },
    'D::C' => sub {
        my @dc = Date::Calc::Add_Delta_DHMS(
            Date::Calc::Today_and_Now(1),
            @dc_tz,
        );
    },
});
