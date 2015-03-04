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


# Подготовка
my $dm = Date::Manip::Date->new;

# Тесты граничиваем тесты по времени а не по количеству циклов. 5 секунд каждый.
my $count = -5;

say "\nСоздание объектов с текущей (локальной) датой:\n";

cmpthese( $count, {
    'Time::Moment' => sub {
        my $tm = Time::Moment->now;
    },
    'DateTime' => sub {
        my $dt = DateTime->now;
    },
    'Date::Manip' => sub {
        my $date = $dm->new_date;
        $date->parse('now');
    },
    'Time::Piece' => sub {
        my $tp = Time::Piece->localtime;
    },
    'Panda::Date (now)' => sub {
        my $pd = Panda::Date::now;
    },
    'Panda::Date (new)' => sub {
        my $pd = Panda::Date->new;
    },
    'Panda::Date (new time)' => sub {
        my $pd = Panda::Date->new(time);
    },
});
