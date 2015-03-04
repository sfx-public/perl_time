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
my $tm1 = Time::Moment->now;

my $dt1 = DateTime->now;
my $dt_duration = DateTime::Duration->new(
    years   => 1,
    months  => 2,
    days    => 3,
    hours   => 4,
    minutes => 5,
    seconds => 6,
);

my $dm = Date::Manip::Date->new;
my $dm_date1 = $dm->new_date;
$dm_date1->parse('now');
my $dm_delta = Date::Manip::Delta->new;
$dm_delta->parse('1:2:0:3:4:5:6');

my $tp1 = Time::Piece->localtime;

my $pd1 = Panda::Date::now;

# Тесты граничиваем тесты по времени а не по количеству циклов. 5 секунд каждый.
my $count = -5;

say "\nСложение:\n";

cmpthese( $count, {
    'Time::Moment' => sub {
        my $tm2 = $tm1->plus_years(1)->plus_months(2)->plus_days(3)->plus_hours(4)->plus_minutes(5)->plus_seconds(6);
    },
    'DateTime' => sub {
        my $dt2 = $dt1 + $dt_duration;
    },
    'Date::Manip' => sub {
        my $dm_date2 = $dm_date1->calc($dm_delta);
    },
    'Time::Piece' => sub {
        my $tp2 = $tp1 + 3 * ONE_DAY + 4 * ONE_HOUR + 5 * ONE_MINUTE + 6;
        $tp2->add_years(1);
        $tp2->add_months(2);
    },
    'Panda::Date (arrayref)' => sub {
        my $pd2 = $pd1 + [1,2,3,4,5,6];
    },
    'Panda::Date (string)' => sub {
        my $pd2 = $pd1 + '1Y 2M 3D 4h 5m 6s';
    },
});
