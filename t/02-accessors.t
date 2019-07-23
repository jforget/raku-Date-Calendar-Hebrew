#
# Checking the getters
#
use v6.c;
use Test;
use Date::Calendar::Hebrew;

plan  11;

my Date::Calendar::Hebrew $d .= new(year => 5779, month => 4, day => 19);

is($d.month,   4);
is($d.day,    19);
is($d.year, 5779);
is($d.gist      , '5779-04-19');
is($d.month-name, 'Tammuz');
#  is($d.day-name,   'Yom Sheni');

# Adar on a regular year
$d .= new(year => 5778, month => 12, day => 19);
is($d.gist      , '5778-12-19');
is($d.month-name, 'Adar');

# Adar on a leap year
$d .= new(year => 5779, month => 12, day => 19);
is($d.gist      , '5779-12-19');
is($d.month-name, 'Adar I');

$d .= new(year => 5779, month => 13, day => 19);
is($d.gist      , '5779-13-19');
is($d.month-name, 'Adar II');

done-testing;
