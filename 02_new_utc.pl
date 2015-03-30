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

use Panda::Date ();

use Date::Calc ();

# Подготовка
my $dm = Date::Manip::Date->new;

# Тесты граничиваем тесты по времени а не по количеству циклов. 5 секунд каждый.
my $count = -5;

say "\nСоздание объектов с текущей (UTC) датой:\n";

cmpthese( $count, {
    'T::M' => sub {
        my $tm = Time::Moment->now_utc;
    },
    'DT' => sub {
        my $dt = DateTime->now( time_zone => 'UTC' );
    },
    'D::M' => sub {
        my $date = $dm->new_date;
        $date->parse('now gtm');
    },
    'T::P' => sub {
        my $tp = Time::Piece->gmtime;
    },
    'P::D' => sub {
        my $pd = Panda::Date->new( time, 'UTC' );
    },
    'D::C' => sub {
        my @dc = Date::Calc::Today_and_Now(1);
    },
});
