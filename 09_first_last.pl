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
use Date::Manip::Delta ();

use Panda::Date ();

# Подготовка
my $dm = Date::Manip::Date->new;

# Тесты граничиваем тесты по времени а не по количеству циклов. 5 секунд каждый.
my $count = -5;

say "\nНачало и конец месяца и недели от текущей даты:\n";

cmpthese( $count, {
    'Time::Moment' => sub {
        my $tm = Time::Moment->now;
        my $week_begin  = $tm->with_day_of_week(1)
            ->with_hour(0)
            ->with_minute(0)
            ->with_second(0)
            ->with_nanosecond(0);
        my $week_end    = $tm->with_day_of_week(7);
        my $month_begin = $tm->with_day_of_month(1);
        my $month_end   = $tm->with_day_of_month( $tm->length_of_month );
    },
    'DateTime' => sub {
        my $dt = DateTime->now;
        my $week_begin  = $dt->clone->truncate( to => 'week' );
        my $week_end    = $week_begin->clone->add( days => 6 );
        my $month_begin = $dt->clone->truncate( to => 'month' );
        my $month_end   = $month_begin->clone->add( months => 1 )->subtract( days => 1 );
    },
    'Date::Manip' => sub {
        my $week_begin = $dm->new_date;
        $week_begin->parse('now');
        $week_begin->prev(1,1,[0,0,0]);

        my $week_end = $dm->new_date;
        $week_end->parse('now');
        $week_end->prev(7,1,[0,0,0]);

        my $month_begin = $dm->new_date;
        $month_begin->parse('now');
        $month_begin->set('time',[0,0,0]);
        $month_begin->set('d',1);

        my $delta = Date::Manip::Delta->new;
        $delta->parse('0:1:0:-1:0:0:0');
        my $month_end = $month_begin->calc( $delta );
    },
    'Panda::Date' => sub {
        my $pd = Panda::Date::now;
        my $week_begin  = $pd->truncate_new;
        $week_begin->day_of_week(2);
        my $week_end    = $week_begin->clone + '6D';
        my $month_begin = $pd->truncate_new->month_begin;
        my $month_end   = $month_begin->month_end;
    },
});
