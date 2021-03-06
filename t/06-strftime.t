#
# Checking the formatting from strftime
#
use v6.c;
use Test;
use Date::Calendar::Hebrew;

my @tests = ((5779,  6,  1, 'zzz',       3, 'zzz')
           , (5779,  6,  1, '%Y-%m-%d', 10, '5779-06-01')
           , (5779,  6,  1, '%j',        3, '357')
           , (5779,  6,  1, '%Oj',       3, '357')
           , (5779,  6,  1, '%Ej',       3, '357')
           , (5779,  6,  1, '%EY',       4, '5779')
           , (5779,  6,  1, '%Ey',       3, '%Ey')
           , (5779,  6,  1, '%A',       10, 'Yom Rishon')
           , (5779,  6,  1, '%u',        1, '1')
           , (5779,  6,  1, '%B',        4, 'Elul')
           , (5779,  6,  1, '%b',        3, 'Elu')
           , (5780,  7,  1, '%j',        3, '001')
           , (5780,  7,  1, '%Y',        4, '5780')
           , (5780,  7,  1, '%G',        4, '5780')
           , (5780,  7,  1, '%V',        2, '01')
           , (5780,  7,  1, '%u',        1, '2')
           , (5780,  7,  1, '%A',        9, 'Yom Sheni')
           , (5780,  7,  1, '%B',        7, 'Tishrey')
             );
plan 2 × @tests.elems;

for @tests -> $test {
  my ($y, $m, $d, $format, $length, $expected) = $test;
  my Date::Calendar::Hebrew $d-heb .= new(year => $y, month => $m, day => $d);
  my $result = $d-heb.strftime($format);

  # Remembering RT ticket 100311 for the Perl 5 module DateTime::Calendar::FrenchRevolutionary
  # Even if the relations between UTF-8 and Perl6 are much simpler than between UTF-8 and Perl5
  # better safe than sorry
  is($result.chars, $length);
  is($result,       $expected);
}

done-testing;
