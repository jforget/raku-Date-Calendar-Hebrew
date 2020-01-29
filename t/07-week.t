#
# Checking the week-related attributes
#
use v6.c;
use Test;
use Date::Calendar::Hebrew;

my @tests = test-data;
plan 2 × @tests.elems;

for @tests -> $test {
  my ($y, $m, $d, $doy, $iso) = $test;
  my Date::Calendar::Hebrew $d-heb .= new(year => $y, month => $m, day => $d);
  is($d-heb.day-of-year          , $doy);
  is($d-heb.strftime('%G-W%V-%u'), $iso);
}

done-testing;

sub test-data {
  return (
              # Year 5749 has 383 days, year 5750 begins on Yom Shabbat
              (5749, 6, 25, 379, '5749-W55-2') #     Yom Sheni 25 Elul 5749
            , (5749, 6, 26, 380, '5749-W55-3') #     Yom Shlishi 26 Elul 5749
            , (5749, 6, 27, 381, '5749-W55-4') # ... Yom Reviʻi 27 Elul 5749
            , (5749, 6, 28, 382, '5749-W55-5') #     Yom Chamishi 28 Elul 5749
            , (5749, 6, 29, 383, '5749-W55-6') #     Yom Shishi 29 Elul 5749
            , (5750, 7,  1,   1, '5749-W55-7') # ^^^ Yom Shabbat 1 Tishrey 5750
            , (5750, 7,  2,   2, '5750-W01-1') # vvv Yom Rishon 2 Tishrey 5750
            , (5750, 7,  3,   3, '5750-W01-2') #     Yom Sheni 3 Tishrey 5750
            , (5750, 7,  4,   4, '5750-W01-3') #     Yom Shlishi 4 Tishrey 5750
            , (5750, 7,  5,   5, '5750-W01-4') # ... Yom Reviʻi 5 Tishrey 5750
            , (5750, 7,  6,   6, '5750-W01-5') #     Yom Chamishi 6 Tishrey 5750
              # Year 5754 has 355 days, year 5755 begins on Yom Shlishi
            , (5754, 6, 25, 351, '5754-W50-5') #     Yom Chamishi 25 Elul 5754
            , (5754, 6, 26, 352, '5754-W50-6') #     Yom Shishi 26 Elul 5754
            , (5754, 6, 27, 353, '5754-W50-7') # ^^^ Yom Shabbat 27 Elul 5754
            , (5754, 6, 28, 354, '5755-W01-1') # vvv Yom Rishon 28 Elul 5754
            , (5754, 6, 29, 355, '5755-W01-2') #     Yom Sheni 29 Elul 5754
            , (5755, 7,  1,   1, '5755-W01-3') #     Yom Shlishi 1 Tishrey 5755
            , (5755, 7,  2,   2, '5755-W01-4') # ... Yom Reviʻi 2 Tishrey 5755
            , (5755, 7,  3,   3, '5755-W01-5') #     Yom Chamishi 3 Tishrey 5755
            , (5755, 7,  4,   4, '5755-W01-6') #     Yom Shishi 4 Tishrey 5755
            , (5755, 7,  5,   5, '5755-W01-7') # ^^^ Yom Shabbat 5 Tishrey 5755
            , (5755, 7,  6,   6, '5755-W02-1') # vvv Yom Rishon 6 Tishrey 5755
              # Year 5755 has 384 days, year 5756 begins on Yom Sheni
            , (5755, 6, 25, 380, '5755-W55-4') # ... Yom Reviʻi 25 Elul 5755
            , (5755, 6, 26, 381, '5755-W55-5') #     Yom Chamishi 26 Elul 5755
            , (5755, 6, 27, 382, '5755-W55-6') #     Yom Shishi 27 Elul 5755
            , (5755, 6, 28, 383, '5755-W55-7') # ^^^ Yom Shabbat 28 Elul 5755
            , (5755, 6, 29, 384, '5756-W01-1') # vvv Yom Rishon 29 Elul 5755
            , (5756, 7,  1,   1, '5756-W01-2') #     Yom Sheni 1 Tishrey 5756
            , (5756, 7,  2,   2, '5756-W01-3') #     Yom Shlishi 2 Tishrey 5756
            , (5756, 7,  3,   3, '5756-W01-4') # ... Yom Reviʻi 3 Tishrey 5756
            , (5756, 7,  4,   4, '5756-W01-5') #     Yom Chamishi 4 Tishrey 5756
            , (5756, 7,  5,   5, '5756-W01-6') #     Yom Shishi 5 Tishrey 5756
            , (5756, 7,  6,   6, '5756-W01-7') # ^^^ Yom Shabbat 6 Tishrey 5756
              # Year 5757 has 383 days, year 5758 begins on Yom Chamishi
            , (5757, 6, 25, 379, '5757-W54-7') # ^^^ Yom Shabbat 25 Elul 5757
            , (5757, 6, 26, 380, '5757-W55-1') # vvv Yom Rishon 26 Elul 5757
            , (5757, 6, 27, 381, '5757-W55-2') #     Yom Sheni 27 Elul 5757
            , (5757, 6, 28, 382, '5757-W55-3') #     Yom Shlishi 28 Elul 5757
            , (5757, 6, 29, 383, '5757-W55-4') # ... Yom Reviʻi 29 Elul 5757
            , (5758, 7,  1,   1, '5757-W55-5') #     Yom Chamishi 1 Tishrey 5758
            , (5758, 7,  2,   2, '5757-W55-6') #     Yom Shishi 2 Tishrey 5758
            , (5758, 7,  3,   3, '5757-W55-7') # ^^^ Yom Shabbat 3 Tishrey 5758
            , (5758, 7,  4,   4, '5758-W01-1') # vvv Yom Rishon 4 Tishrey 5758
            , (5758, 7,  5,   5, '5758-W01-2') #     Yom Sheni 5 Tishrey 5758
            , (5758, 7,  6,   6, '5758-W01-3') #     Yom Shlishi 6 Tishrey 5758
              # Year 5761 has 353 days, year 5762 begins on Yom Shlishi
            , (5761, 6, 25, 349, '5761-W50-5') #     Yom Chamishi 25 Elul 5761
            , (5761, 6, 26, 350, '5761-W50-6') #     Yom Shishi 26 Elul 5761
            , (5761, 6, 27, 351, '5761-W50-7') # ^^^ Yom Shabbat 27 Elul 5761
            , (5761, 6, 28, 352, '5762-W01-1') # vvv Yom Rishon 28 Elul 5761
            , (5761, 6, 29, 353, '5762-W01-2') #     Yom Sheni 29 Elul 5761
            , (5762, 7,  1,   1, '5762-W01-3') #     Yom Shlishi 1 Tishrey 5762
            , (5762, 7,  2,   2, '5762-W01-4') # ... Yom Reviʻi 2 Tishrey 5762
            , (5762, 7,  3,   3, '5762-W01-5') #     Yom Chamishi 3 Tishrey 5762
            , (5762, 7,  4,   4, '5762-W01-6') #     Yom Shishi 4 Tishrey 5762
            , (5762, 7,  5,   5, '5762-W01-7') # ^^^ Yom Shabbat 5 Tishrey 5762
            , (5762, 7,  6,   6, '5762-W02-1') # vvv Yom Rishon 6 Tishrey 5762
              # Year 5763 has 385 days, year 5764 begins on Yom Shabbat
            , (5763, 6, 25, 381, '5763-W55-2') #     Yom Sheni 25 Elul 5763
            , (5763, 6, 26, 382, '5763-W55-3') #     Yom Shlishi 26 Elul 5763
            , (5763, 6, 27, 383, '5763-W55-4') # ... Yom Reviʻi 27 Elul 5763
            , (5763, 6, 28, 384, '5763-W55-5') #     Yom Chamishi 28 Elul 5763
            , (5763, 6, 29, 385, '5763-W55-6') #     Yom Shishi 29 Elul 5763
            , (5764, 7,  1,   1, '5763-W55-7') # ^^^ Yom Shabbat 1 Tishrey 5764
            , (5764, 7,  2,   2, '5764-W01-1') # vvv Yom Rishon 2 Tishrey 5764
            , (5764, 7,  3,   3, '5764-W01-2') #     Yom Sheni 3 Tishrey 5764
            , (5764, 7,  4,   4, '5764-W01-3') #     Yom Shlishi 4 Tishrey 5764
            , (5764, 7,  5,   5, '5764-W01-4') # ... Yom Reviʻi 5 Tishrey 5764
            , (5764, 7,  6,   6, '5764-W01-5') #     Yom Chamishi 6 Tishrey 5764
              # Year 5768 has 383 days, year 5769 begins on Yom Shlishi
            , (5768, 6, 25, 379, '5768-W54-5') #     Yom Chamishi 25 Elul 5768
            , (5768, 6, 26, 380, '5768-W54-6') #     Yom Shishi 26 Elul 5768
            , (5768, 6, 27, 381, '5768-W54-7') # ^^^ Yom Shabbat 27 Elul 5768
            , (5768, 6, 28, 382, '5769-W01-1') # vvv Yom Rishon 28 Elul 5768
            , (5768, 6, 29, 383, '5769-W01-2') #     Yom Sheni 29 Elul 5768
            , (5769, 7,  1,   1, '5769-W01-3') #     Yom Shlishi 1 Tishrey 5769
            , (5769, 7,  2,   2, '5769-W01-4') # ... Yom Reviʻi 2 Tishrey 5769
            , (5769, 7,  3,   3, '5769-W01-5') #     Yom Chamishi 3 Tishrey 5769
            , (5769, 7,  4,   4, '5769-W01-6') #     Yom Shishi 4 Tishrey 5769
            , (5769, 7,  5,   5, '5769-W01-7') # ^^^ Yom Shabbat 5 Tishrey 5769
            , (5769, 7,  6,   6, '5769-W02-1') # vvv Yom Rishon 6 Tishrey 5769
              # Year 5769 has 354 days, year 5770 begins on Yom Shabbat
            , (5769, 6, 25, 350, '5769-W51-2') #     Yom Sheni 25 Elul 5769
            , (5769, 6, 26, 351, '5769-W51-3') #     Yom Shlishi 26 Elul 5769
            , (5769, 6, 27, 352, '5769-W51-4') # ... Yom Reviʻi 27 Elul 5769
            , (5769, 6, 28, 353, '5769-W51-5') #     Yom Chamishi 28 Elul 5769
            , (5769, 6, 29, 354, '5769-W51-6') #     Yom Shishi 29 Elul 5769
            , (5770, 7,  1,   1, '5769-W51-7') # ^^^ Yom Shabbat 1 Tishrey 5770
            , (5770, 7,  2,   2, '5770-W01-1') # vvv Yom Rishon 2 Tishrey 5770
            , (5770, 7,  3,   3, '5770-W01-2') #     Yom Sheni 3 Tishrey 5770
            , (5770, 7,  4,   4, '5770-W01-3') #     Yom Shlishi 4 Tishrey 5770
            , (5770, 7,  5,   5, '5770-W01-4') # ... Yom Reviʻi 5 Tishrey 5770
            , (5770, 7,  6,   6, '5770-W01-5') #     Yom Chamishi 6 Tishrey 5770
              # Year 5770 has 355 days, year 5771 begins on Yom Chamishi
            , (5770, 6, 25, 351, '5770-W50-7') # ^^^ Yom Shabbat 25 Elul 5770
            , (5770, 6, 26, 352, '5770-W51-1') # vvv Yom Rishon 26 Elul 5770
            , (5770, 6, 27, 353, '5770-W51-2') #     Yom Sheni 27 Elul 5770
            , (5770, 6, 28, 354, '5770-W51-3') #     Yom Shlishi 28 Elul 5770
            , (5770, 6, 29, 355, '5770-W51-4') # ... Yom Reviʻi 29 Elul 5770
            , (5771, 7,  1,   1, '5770-W51-5') #     Yom Chamishi 1 Tishrey 5771
            , (5771, 7,  2,   2, '5770-W51-6') #     Yom Shishi 2 Tishrey 5771
            , (5771, 7,  3,   3, '5770-W51-7') # ^^^ Yom Shabbat 3 Tishrey 5771
            , (5771, 7,  4,   4, '5771-W01-1') # vvv Yom Rishon 4 Tishrey 5771
            , (5771, 7,  5,   5, '5771-W01-2') #     Yom Sheni 5 Tishrey 5771
            , (5771, 7,  6,   6, '5771-W01-3') #     Yom Shlishi 6 Tishrey 5771
              # Year 5777 has 353 days, year 5778 begins on Yom Chamishi
            , (5777, 6, 25, 349, '5777-W50-7') # ^^^ Yom Shabbat 25 Elul 5777
            , (5777, 6, 26, 350, '5777-W51-1') # vvv Yom Rishon 26 Elul 5777
            , (5777, 6, 27, 351, '5777-W51-2') #     Yom Sheni 27 Elul 5777
            , (5777, 6, 28, 352, '5777-W51-3') #     Yom Shlishi 28 Elul 5777
            , (5777, 6, 29, 353, '5777-W51-4') # ... Yom Reviʻi 29 Elul 5777
            , (5778, 7,  1,   1, '5777-W51-5') #     Yom Chamishi 1 Tishrey 5778
            , (5778, 7,  2,   2, '5777-W51-6') #     Yom Shishi 2 Tishrey 5778
            , (5778, 7,  3,   3, '5777-W51-7') # ^^^ Yom Shabbat 3 Tishrey 5778
            , (5778, 7,  4,   4, '5778-W01-1') # vvv Yom Rishon 4 Tishrey 5778
            , (5778, 7,  5,   5, '5778-W01-2') #     Yom Sheni 5 Tishrey 5778
            , (5778, 7,  6,   6, '5778-W01-3') #     Yom Shlishi 6 Tishrey 5778
              # Year 5778 has 354 days, year 5779 begins on Yom Sheni
            , (5778, 6, 25, 350, '5778-W50-4') # ... Yom Reviʻi 25 Elul 5778
            , (5778, 6, 26, 351, '5778-W50-5') #     Yom Chamishi 26 Elul 5778
            , (5778, 6, 27, 352, '5778-W50-6') #     Yom Shishi 27 Elul 5778
            , (5778, 6, 28, 353, '5778-W50-7') # ^^^ Yom Shabbat 28 Elul 5778
            , (5778, 6, 29, 354, '5779-W01-1') # vvv Yom Rishon 29 Elul 5778
            , (5779, 7,  1,   1, '5779-W01-2') #     Yom Sheni 1 Tishrey 5779
            , (5779, 7,  2,   2, '5779-W01-3') #     Yom Shlishi 2 Tishrey 5779
            , (5779, 7,  3,   3, '5779-W01-4') # ... Yom Reviʻi 3 Tishrey 5779
            , (5779, 7,  4,   4, '5779-W01-5') #     Yom Chamishi 4 Tishrey 5779
            , (5779, 7,  5,   5, '5779-W01-6') #     Yom Shishi 5 Tishrey 5779
            , (5779, 7,  6,   6, '5779-W01-7') # ^^^ Yom Shabbat 6 Tishrey 5779
              # Year 5779 has 385 days, year 5780 begins on Yom Sheni
            , (5779, 6, 25, 381, '5779-W55-4') # ... Yom Reviʻi 25 Elul 5779
            , (5779, 6, 26, 382, '5779-W55-5') #     Yom Chamishi 26 Elul 5779
            , (5779, 6, 27, 383, '5779-W55-6') #     Yom Shishi 27 Elul 5779
            , (5779, 6, 28, 384, '5779-W55-7') # ^^^ Yom Shabbat 28 Elul 5779
            , (5779, 6, 29, 385, '5780-W01-1') # vvv Yom Rishon 29 Elul 5779
            , (5780, 7,  1,   1, '5780-W01-2') #     Yom Sheni 1 Tishrey 5780
            , (5780, 7,  2,   2, '5780-W01-3') #     Yom Shlishi 2 Tishrey 5780
            , (5780, 7,  3,   3, '5780-W01-4') # ... Yom Reviʻi 3 Tishrey 5780
            , (5780, 7,  4,   4, '5780-W01-5') #     Yom Chamishi 4 Tishrey 5780
            , (5780, 7,  5,   5, '5780-W01-6') #     Yom Shishi 5 Tishrey 5780
            , (5780, 7,  6,   6, '5780-W01-7') # ^^^ Yom Shabbat 6 Tishrey 5780
              # Year 5780 has 355 days, year 5781 begins on Yom Shabbat
            , (5780, 6, 25, 351, '5780-W51-2') #     Yom Sheni 25 Elul 5780
            , (5780, 6, 26, 352, '5780-W51-3') #     Yom Shlishi 26 Elul 5780
            , (5780, 6, 27, 353, '5780-W51-4') # ... Yom Reviʻi 27 Elul 5780
            , (5780, 6, 28, 354, '5780-W51-5') #     Yom Chamishi 28 Elul 5780
            , (5780, 6, 29, 355, '5780-W51-6') #     Yom Shishi 29 Elul 5780
            , (5781, 7,  1,   1, '5780-W51-7') # ^^^ Yom Shabbat 1 Tishrey 5781
            , (5781, 7,  2,   2, '5781-W01-1') # vvv Yom Rishon 2 Tishrey 5781
            , (5781, 7,  3,   3, '5781-W01-2') #     Yom Sheni 3 Tishrey 5781
            , (5781, 7,  4,   4, '5781-W01-3') #     Yom Shlishi 4 Tishrey 5781
            , (5781, 7,  5,   5, '5781-W01-4') # ... Yom Reviʻi 5 Tishrey 5781
            , (5781, 7,  6,   6, '5781-W01-5') #     Yom Chamishi 6 Tishrey 5781
            );
}
