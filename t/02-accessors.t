#
# Checking the getters
#
use v6.c;
use Test;
use Date::Calendar::Hebrew;

plan  18;

my Date::Calendar::Hebrew $d .= new(year => 5779, month => 4, day => 19);

is($d.month,   4);
is($d.day,    19);
is($d.year, 5779);
is($d.gist      , '5779-04-19');
is($d.month-abbr, 'Tam');
is($d.month-name, 'Tamuz');
is($d.day-name,   'Yom Sheni');

# Adar on a regular year
$d .= new(year => 5778, month => 12, day => 19);
is($d.gist      , '5778-12-19');
is($d.month-name, 'Adar');
is($d.month-abbr, 'Ada');

# Adar on a leap year
$d .= new(year => 5779, month => 12, day => 19);
is($d.gist      , '5779-12-19');
is($d.month-name, 'Adar I');
is($d.month-abbr, 'Ad1');

$d .= new(year => 5779, month => 13, day => 19);
is($d.gist      , '5779-13-19');
is($d.month-name, 'Adar II');
is($d.month-abbr, 'Ad2');

# Av month
$d .= new(year => 5780, month =>  5, day => 10);
is($d.month-name, 'Av');
is($d.month-abbr, 'Av '); # 3-char abbreviation for a 2-char month!

done-testing;
