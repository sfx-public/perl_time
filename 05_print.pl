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

# Подготовим дату перед циклами проверки
my $tm = Time::Moment->now;

my $dt_formatter = DateTime::Format::Strptime->new( pattern => '%Y.%m.%d %H-%M-%S (%9N) %z', on_error  => 'croak' );
my $dt = DateTime->now;

my $dm = Date::Manip::Date->new;
my $dm_date = $dm->new_date;
$dm_date->parse('now');

my $tp = Time::Piece->localtime;

my $pd = Panda::Date::now;

# Тесты граничиваем тесты по времени а не по количеству циклов. 5 секунд каждый.
my $count = -5;

say "\nПолучение строки по шаблону:\n";

cmpthese( $count, {
    'Time::Moment' => sub {
        my $str = $tm->strftime("%Y.%m.%d %H-%M-%S (%f) %z");
    },
    'DateTime' => sub {
        my $str = $dt_formatter->format_datetime($dt);
    },
    'Date::Manip' => sub {
        my $str = $dm_date->printf("%Y.%m.%d %H-%M-%S (%f) %z");
    },
    'Time::Piece' => sub {
        my $str = $tp->strftime("%Y.%m.%d %H-%M-%S %z");
    },
    'Panda::Date' => sub {
        my $str = $pd->strftime("%Y.%m.%d %H-%M-%S %z");
    },
});
