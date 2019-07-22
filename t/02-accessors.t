#
# Checking the getters
#
use v6.c;
use Test;
use Date::Calendar::Hebrew;

plan  3;

my Date::Calendar::Hebrew $d .= new(year => 5779, month => 4, day => 19);

is($d.month,   4);
is($d.day,    19);
is($d.year, 5779);
#  is($d.month-name, 'Tammuz');
#  is($d.day-name,   'Yom Sheni');

done-testing;
