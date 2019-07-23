#
# Checking the conversions
#
use v6.c;
use Test;
use Date::Calendar::Hebrew;

# Hebrew dates picked from the various Hebrew calendar Perl 5 modules
# Gregorian dates computed with Nachum Dershowitz and Edward M. Reingold's calendrica-3.0.cl
my @test-data = (
       <5703  1 14    1943  4 19>
     , <5770  1  1    2010  3 16>
     , <5771  1  1    2011  4  5>
     #----------------------------------- From rt.cpan.org Date::Convert::Hebrew
     , <5717 12 29    1957  3  2>
     , <5717  6 29    1957  9 25>
     , <5770 12 16    2010  3  2>
     #----------------------------------- From t/*.t Date::Convert::Hebrew
     , <5757 13  9    1997  3 18>
     , <5735  9 13    1974 11 27>
     , <5756  7  8    1995 10  2>
     , <5736  2 25    1976  5 25>
     , <5765 10 26    2005  1  7>
     #-----------------------------------  From t/*.t Date::Hebrew::Simple
     , <5778 11  1    2018  1 17>
     , <5778 11 27    2018  2 12>
     #----------------------------------- From t/*.t DateTime::Calendar::Hebrew
     , <5708  2  5    1948  5 14>
     , <2449  1 15   -1311  3 31>
     , <3339  5  9    -421  7 29>
     , <5735 10  5    1974 12 19>
     , <3829  5  9      69  7 14>
     , <5763  1  1    2003  4  3>
     , <5763  5 23    2003  8 21>
     , <5764  7  1    2003  9 27>
     , <   1  1  1   -3759  3  4>
     #----------------------------------- from t/*.t Date::Converter
     , <3593  9 25    -168 12  5>
     , <3831  7  3      70  9 24>
     , <4230 10 18     470  1  8>
     , <4336  3  4     576  5 20>
     , <4455  8 13     694 11 10>
     , <4773  2  6    1013  4 25>
     , <4856  2 23    1096  5 24>
     , <4950  1  7    1190  3 23>
     , <5000 13  8    1240  3 10>
     , <5048  1 21    1288  4  2>
     , <5058  2  7    1298  4 27>
     , <5151  4  1    1391  6 12>
     , <5196 11  7    1436  2  3>
     , <5252  1  3    1492  4  9>
     , <5314  7  1    1553  9 19>
     , <5320 12 27    1560  3  5>
     , <5408  3 20    1648  6 10>
     , <5440  4  3    1680  6 30>
     , <5476  5  5    1716  7 24>
     , <5528  4  4    1768  6 19>
     , <5579  5 11    1819  8  2>
     , <5599  1 12    1839  3 27>
     , <5663  1 22    1903  4 19>
     , <5689  5 19    1929  8 25>
     , <5702  7  8    1941  9 29>
     , <5703  1 14    1943  4 19>
     , <5704  7  8    1943 10  7>
     , <5752 13 12    1992  3 17>
     , <5756 12  5    1996  2 25>
     , <5799  8 12    2038 11 10>
     , <5854  5  5    2094  7 18>
     #----------------------------------- Around the Gregorian epoch
     , <3761  5  5       1  7 13>
     , <3760  5  5       0  7 23>
     , <3759  5  5      -1  7  4>
);

plan  1 × @test-data.elems;

for @test-data -> $datum {
  my ($y-he, $m-he, $d-he, $y-gr, $m-gr, $d-gr) = $datum;
  my Date $date-gr .= new($y-gr, $m-gr, $d-gr);
  my Date::Calendar::Hebrew $date-he .= new-from-date($date-gr);
  my $expected = sprintf("%04d-%02d-%02d", $y-he, $m-he, $d-he);
  is($date-he.gist, $expected);
}

#for @test-data -> $datum {
#  my ($y-he, $m-he, $d-he, $y-gr, $m-gr, $d-gr) = $datum;
#  my Date::Calendar::Hebrew $date-he .= new(year => +$y-he, month => +$m-he, day => +$d-he);
#  my Date $date-gr = $date-he.to-date;
#  my $expected = sprintf("%04d-%02d-%02d", $y-gr, $m-gr, $d-gr);
#  is($date-gr.gist, $expected);
#}

done-testing;
