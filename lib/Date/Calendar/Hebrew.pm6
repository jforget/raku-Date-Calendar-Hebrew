use v6.c;
use Date::Calendar::Strftime;
use Date::Calendar::Hebrew::Names;
use List::MoreUtils <before>;

unit class Date::Calendar::Hebrew:ver<0.0.3>:auth<cpan:JFORGET>
      does Date::Calendar::Strftime;

has Int $.year  where { $_ ≥ 1 };
has Int $.month where { 1 ≤ $_ ≤ 13 };
has Int $.day   where { 1 ≤ $_ ≤ 30 };
has Int $.daycount;
has Int $.day-of-year;
has Int $.day-of-week;
has Int $.week-number;
has Int $.week-year;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day) {
  $._chek-build-args($year, $month, $day);
  $._build-from-args($year, $month, $day);
}

method _chek-build-args(Int $year, Int $month, Int $day) {
  if is-leap($year) {
    unless 1 ≤ $month ≤ 13 {
      X::OutOfRange.new(:what<Month>, :got($month), :range<1..13 for a leap year>).throw;
    }
  }
  else {
    unless 1 ≤ $month ≤ 12 {
      X::OutOfRange.new(:what<Month>, :got($month), :range<1..12 for a normal year>).throw;
    }
  }
  my $limit =  month-days($year, $month);
  if $day == 0 || $day > $limit {
    X::OutOfRange.new(:what<Day>, :got($day), :range("1..$limit for this month and this year")).throw;
  }
}

method _build-from-args(Int $year, Int $month, Int $day) {
  $!year   = $year;
  $!month  = $month;
  $!day    = $day;

  # computing derived attributes
  my Int $jed        = ymdf-to-jed($year, $month, $day);
  my Int $daycount   = $jed - mjd-to-jed();
  my Int $doy        = $jed - ymdf-to-jed($year, 7, 1) + 1;
  my Int $dow        = ($daycount + 3) % 7 + 1;

  # storing derived attributes
  $!day-of-year = $doy;
  $!day-of-week = $dow;
  $!daycount    = $daycount;

  # computing week-related derived attributes
  my Int $doy-revi'i = $doy - $dow + 4; # day-of-year value for the nearest Yom Revi'i / Wednesday
  my Int $week-year  = $year;
  if $doy-revi'i ≤ 0 {
    -- $week-year;
    $doy       += year-days($week-year);
    $doy-revi'i = $doy - $dow + 4;
  }
  else {
    my $year-length = year-days($week-year);
    if $doy-revi'i > $year-length {
      $doy       -= $year-length;
      $doy-revi'i = $doy - $dow + 4;
      ++ $week-year;
    }
  }
  my Int $week-number = ($doy-revi'i / 7).ceiling;

  # storing week-related derived attributes
  $!week-number = $week-number;
  $!week-year   = $week-year;
}

method gist {
  sprintf("%04d-%02d-%02d", $.year, $.month, $.day);
}

method month-name {
  Date::Calendar::Hebrew::Names::month-name($.month, $.is-leap);
}

method month-abbr {
  Date::Calendar::Hebrew::Names::month-abbr($.month, $.is-leap);
}

method day-name {
  Date::Calendar::Hebrew::Names::day-name($.day-of-week - 1);
}

method is-leap {
  is-leap($.year);
}

method new-from-date($date) {
  $.new-from-daycount($date.daycount);
}

method new-from-daycount(Int $count) {
  my ($y, $m, $d) = jed-to-ymdf($count + mjd-to-jed());
  $.new(year => $y, month => $m, day => $d);
}

method to-date($class = 'Date') {
  # See "Learning Perl 6" page 177
  my $d = ::($class).new-from-daycount($.daycount);
  return $d;
}

sub is-leap(Int $year --> Any) {
  return (7 × $year + 1) % 19 < 7;
}

sub mjd-to-jed {
  2_086_804;
}

sub rata-die-to-mjd {
  1408228;
}

sub epoch {
  34799;
}

sub year-months(Int $year --> Int) {
  return 13 if is-leap($year);
  return 12;
}

sub delay_1(Int $year --> Int) {
  my $months = ((235 × $year - 234) / 19).floor;
  my $parts  = 12084 + 13753 × $months;
  my $day    = 29 × $months + ($parts / 25920).floor;
  if (3 × ($day + 1)) % 7 < 3 {
    ++$day;
  }
  return $day;
}

sub delay_2(Int $year --> Int) {
  my $last    = delay_1($year - 1);
  my $present = delay_1($year    );
  my $next    = delay_1($year + 1);
  if $next - $present == 356 {
    return 2;
  }
  elsif $present - $last == 382 {
    return 1;
  }
  else {
    return 0;
  }
}

# 29-day months: Iyar, Tamuz, Elul, Heshvan (on 353, 354, 383 and 384-day years),
#                Kislev (on 353 and 383-day years), Tevet, Adar (when non leap) and Adar II (when leap)
# 30-day months: Nisan, Sivan, Av, Tishrey, Heshvan (on 355 and 385-day years),
#                Kislev (on 354, 355, 384 and 385-day years), Shvat and Adar I (when leap)
sub month-days(Int $year, Int $month --> Int) {
 return 29 if $month ==  2 | 4 | 6 | 10 | 13;
 return 29 if $month == 12 && ! is-leap($year);
 return 29 if $month ==  8 && year-days($year) % 10 != 5;
 return 29 if $month ==  9 && year-days($year) % 10 == 3;
 return 30;

}

sub year-days(Int $year --> Int) {
  ymdf-to-jed($year + 1, 7, 1) - ymdf-to-jed($year, 7, 1);
}

sub ymdf-to-jed(Int $year, Int $month, Int $day --> Int) {
  # Not directly translated from Perl 5 into Perl 6, but Perl 5 → APL → Perl 6
  # We suppose we have already a function with signature
  #      R ← year_months Y
  # which gives a 12 or 13 result depending on the year type (normal / leap)
  # and a function with signature
  #      R ← Y month_days M
  # which gives a 29 or 30 result for the month length.
  # The currified form of this last function in APL syntax is
  #      { year month_days ⍵ }
  # (I hope so, I have not checked the documentation).
  # So the first line
  #      V ← 6 ⌽ ⍳ year_months year
  # gives the month numbers in the order in which they appear, 7 8 9 10 11 12 1 2 3 4 5 6
  # (or  7 8 9 10 11 12 13 1 2 3 4 5 6 on leap years)
  # The partial second line
  #      (¯1 + V ⍳ month) ↑ V
  # gives the list of months to process to obtain the number of days from the beginning
  # of the year to the target month (not included).
  # And the second line adds the number of days in the months before the target month
  #      +/ { year month_days ⍵ } [ (¯1 + V ⍳ month) ↑ V ]

  # Another important point: ymdf-to-jed calls month-days which calls year-days which calls ymdf-to-jed
  # What about a runaway recursion? 
  # No worries. As long as year-days calls ymdf-to-jed with a month parameter equal to 7, this instance of
  # ymdf-to-jed will deal with an empty list of month numbers, so it will not call month-days again.

  my @V = (1 .. year-months $year);

  return  epoch()
         + delay_1($year)
         + delay_2($year)
         + $day + 1
         + [+] map { month-days($year, $_) }, (before { $_ == $month }, @V.rotate(6))
         ;
}

sub jed-to-ymdf(Int $jed) {
  my ($y, $m, $d);
  my Rat $jed-r = $jed.floor + 0.5;
  $y = (98496.0 × ($jed-r - epoch()) / 35975351.0).floor - 1;
  while ymdf-to-jed($y + 1, 7, 1) ≤ $jed {
    ++$y;
    #say $y;
  }

  my @V = (1 .. year-months $y);
  for @V.rotate(6) -> $m1 {
    last if ymdf-to-jed($y, $m1, 1) > $jed;
    $m = $m1;
    #say $m;
  }
  return ($y, $m, 1 + $jed - ymdf-to-jed($y, $m, 1));
}

=begin pod

=head1 NAME

Date::Calendar::Hebrew - Conversions from / to the Hebrew calendar

=head1 SYNOPSIS

Converting a Gregorian date (e.g. 16th June 2019) into Hebrew

=begin code :lang<perl6>

use Date::Calendar::Hebrew;
my Date                   $TPC2019-Pittsburgh-grg;
my Date::Calendar::Hebrew $TPC2019-Pittsburgh-heb;

$TPC2019-Pittsburgh-grg .= new(2019, 6, 16);
$TPC2019-Pittsburgh-heb .= new-from-date($TPC2019-Pittsburgh-grg);

say $TPC2019-Pittsburgh-heb;
# --> 5779-03-13
say "{.day-name} {.day} {.month-name} {.year}" with $TPC2019-Pittsburgh-heb;
# --> Yom Rishon 13 Sivan 5779
say $TPC2019-Pittsburgh-heb.strftime("%A %d %B %Y");
# --> Yom Rishon 13 Sivan 5779

=end code

Converting an Hebrew date (e.g. 6 Av 5779) into Gregorian

=begin code :lang<perl6>

use Date::Calendar::Hebrew;
my Date::Calendar::Hebrew $Perlcon-Riga-heb;
my Date                   $Perlcon-Riga-grg;

$Perlcon-Riga-heb .= new(year  => 5779
                       , month =>    5
                       , day   =>    6);
$Perlcon-Riga-grg = $Perlcon-Riga-heb.to-date;

say $Perlcon-Riga-grg;

=end code

=head1 DESCRIPTION

Date::Calendar::Hebrew  is a  class representing  dates in  the Hebrew
calendar. It allows  you to convert an Hebrew date  into Gregorian (or
possibly other) calendar and the other way.

The Hebrew calendar  is a luni-solar calendar. Some  months are 29-day
long, other are  30-day long and still other varies  between 29 and 30
from a year  to the other, so  on average, the duration of  a month is
very close  to the  duration of a  lunation. The years  have 12  or 13
months, so  while the duration  of the Hebrew year  oscillates between
353 and 385 days,  on average it is very close to  the duration of the
tropic year.

The switch from  a date to the  next occurs at sunset.  This point has
not been implemented in this module, conversions are valid only before
sunset. So,  while 16th June 2019  at noon converts to  13 Sivan 5779,
16th June 2019 at 23:59 really is 14 Sivan 5779.

A peculiar characteristic  of this calendar is that the  switch from a
year to the next occurs when switching  from month 6 to month 7. So we
have the following:

  2019-04-05   5779-13-29 Yom Shishi 29 Adar II 5779
  2019-04-06   5779-01-01 Yom Shabbat 1 Nisan 5779 --> no change of year
  ...
  2019-09-29   5779-06-29 Yom Rishon 29 Elul 5779
  2019-09-30   5780-07-01 Yom Sheni 1 Tishrey 5780 --> new year

=head1 METHODS

=head2 Constructors

=head3 new

Create an Hebrew date by giving the year, month and day numbers.

=head3 new-from-date

Build an  Hebrew date by  cloning an  object from another  class. This
other   class    can   be    the   core    class   C<Date>    or   any
C<Date::Calendar::>R<xxx> class with a C<daycount> method.

=head3 new-from-daycount

Build an Hebrew date from the Modified Julian Day number.

=head2 Accessors

=head3 gist

Gives a short string representing the date, in C<YYYY-MM-DD> format.

=head3 year, month, day

The numbers defining the date.

=head3 month-name

The month of the date, as a string.

=head3 month-abbr

The month of the  date, as a 3-char string.

This is  always a 3-char  string, even for  month "Av". The  reason is
that the  abbreviations are often used  in tables and arrays  so that,
when typescripted  with a constant-width  font, it keeps  the vertical
alignment of the table elements. Therefore, the abbreviation is 3-char
for all months.

=head3 day-name

The name of the day within  the week.

=head3 daycount

Convert  the date  to Modified  Julian Day  Number (a  day-only scheme
based on 17 November 1858).

=head3 day-of-week

The number of  the day within the  week (1 for Sunday /  Yom Rishon, 7
for Saturday / Yom Shabbat).

=head3 week-number

The number of the  week within the year, 1 to 50 or  1 to 51 on normal
years, 1 to 54 or 1 to 55  on leap years. Similar to the "ISO date" as
defined for  Gregorian date. Week  number 1  is the Sun→Sat  span that
contains the first  Wednesday / Yom Revi'i of the  year, week number 2
is the Sun→Sat span that contains the second Wednesday / Yom Revi'i of
the year and so on.

=head3 week-year

Mostly similar  to the C<year>  attribute. Yet,  the last days  of the
year  and  the  first  days  of the  following  year  can  be  sort-of
transferred  to the  other year.  The C<week-year>  attribute reflects
this transfer.  While the real year  always begins on 1st  Tishrey and
ends on the 29th Elul, the  C<week-year> always begins on Sunday / Yom
Rishon and it always ends on Saturday / Yom Shabbat.

=head3 day-of-year

How many  days since the beginning  of the year.  1 to 353 (or  354 or
355) on normal years, 1 to 383 (or 384 or 385) on leap years.

=head2 Other Methods

=head3 to-date

Clones  the   date  into   a  core  class   C<Date>  object   or  some
C<Date::Calendar::>R<xxx> compatible calendar  class. The target class
name is given  as a positional parameter. This  parameter is optional,
the default value is C<"Date"> for the Gregorian calendar.

To convert a date from a  calendar to another, you have two conversion
styles,  a "push"  conversion and  a "pull"  conversion. For  example,
while converting "26 Tamuz 5779" to the French Revolutionary calendar,
you can code:

=begin code :lang<perl6>

use Date::Calendar::Hebrew;
use Date::Calendar::FrenchRevolutionary;

my  Date::Calendar::Hebrew              $d-orig;
my  Date::Calendar::FrenchRevolutionary $d-dest-push;
my  Date::Calendar::FrenchRevolutionary $d-dest-pull;

$d-orig .= new(year  => 5779
             , month =>    4
             , day   =>   26);
$d-dest-push  = $d-orig.to-date("Date::Calendar::FrenchRevolutionary");
$d-dest-pull .= new-from-date($d-orig);

=end code

When converting I<from> Gregorian, use the pull style. When converting
I<to> Gregorian, use the push style. When converting from any calendar
other than Gregorian  to any other calendar other  than Gregorian, use
the style you prefer.

=head3 strftime

This method is  very similar to the homonymous functions  you can find
in several  languages (C, shell, etc).  It also takes some  ideas from
C<printf>-similar functions. For example

=begin code :lang<perl6>

$df.strftime("%04d blah blah blah %-25B")

=end code

will give  the day number  padded on  the left with  2 or 3  zeroes to
produce a 4-digit substring, plus the substring C<" blah blah blah ">,
plus the month name, padded on the right with enough spaces to produce
a 25-char substring. Thus, the whole  string will be at least 42 chars
long. By  the way, you  can drop the  "at least" mention,  because the
longest month  name is 7-char long,  so the padding will  always occur
and will always include at least 18 spaces.

A C<strftime> specifier consists of:

=item A percent sign,

=item An  optional minus sign, to  indicate on which side  the padding
occurs. If the minus sign is present, the value is aligned to the left
and the padding spaces are added to the right. If it is not there, the
value is aligned to the right and the padding chars (spaces or zeroes)
are added to the left.

=item  An  optional  zero  digit,  to  choose  the  padding  char  for
right-aligned values.  If the  zero char is  present, padding  is done
with zeroes. Else, it is done wih spaces.

=item An  optional length, which  specifies the minimum length  of the
result substring.

=item  An optional  C<"E">  or  C<"O"> modifier.  On  some older  UNIX
system,  these  were used  to  give  the I<extended>  or  I<localized>
version  of  the date  attribute.  Here,  they rather  give  alternate
variants of the date attribute. Not used with the Hebrew calendar.

=item A mandatory type code.

The allowed type codes are:

=defn C<%A>

The full day of week name.

=defn C<%b>

The abbreviated month name.

=defn C<%B>

The full month name.

=defn C<%d>

The day of the month as a decimal number (range 01 to 30).

=defn C<%e>

Like C<%d>, the  day of the month  as a decimal number,  but a leading
zero is replaced by a space.

=defn C<%f>

The month as a decimal number (1  to 13). Unlike C<%m>, a leading zero
is replaced by a space.

=defn C<%F>

Equivalent to %Y-%m-%d (the ISO 8601 date format)

=defn C<%G>

The "week year"  as a decimal number. Mostly similar  to C<%Y>, but it
may differ  on the very  first days  of the year  or on the  very last
days. Analogous to the year number  in the so-called "ISO date" format
for Gregorian dates.

=defn C<%j>

The day of the year as a decimal number (range 001 to 385).

=defn C<%L>

Redundant with C<%Y> and strongly discouraged: the year number.

=defn C<%m>

The month as a two-digit decimal  number (range 01 to 13), including a
leading zero if necessary.

=defn C<%n>

A newline character.

=defn C<%t>

A tab character.

=defn C<%u>

The day of week as a 1..7 number.

=defn C<%V>

The week  number as defined above,  similar to the week  number in the
so-called "ISO date" format for Gregorian dates.

=defn C<%Y>

The year as a decimal number.

=defn C<%%>

A literal `%' character.


=head1 PROBLEMS AND KNOWN BUGS

The  conversions are  valid before  sunset. It  is up  to the  user to
assert the  need of incrementing  the Hebrew date or  decrementing the
Gregorian date if the time of day is in the evening after sunset.

I have found  no source for day abbreviations, so  only the months are
abbreviated.

=head1 SEE ALSO

=head2 Raku Software

L<Date::Calendar::Strftime>
or L<https://github.com/jforget/raku-Date-Calendar-Strftime>

L<Date::Calendar::CopticEthiopic>
or L<https://github.com/jforget/raku-Date-Calendar-CopticEthiopic>

L<Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

Maybe someday, L<Date::Calendar::Julian>
or L<https://github.com/jforget/raku-Date-Calendar-Julian>

=head2 Perl 5 Software

L<DateTime>

L<DateTime::Calendar::Hebrew>

L<Date::Convert>

L<Date::Hebrew::Simple>

L<Date::Converter> which I used as a model for the computations in this module.

L<DateTime::Event::Jewish::Sunrise>

=head2 Other Software

date(1), strftime(3)

F<calendar/cal-hebrew.el>  in emacs.2  or xemacs.

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>
(Actually, I have used the 3.0 version which is not longer available)

=head2 Books

Calendrical Calculations (Third or Fourth Edition) by Nachum Dershowitz and
Edward M. Reingold, Cambridge University Press, see
L<http://www.calendarists.com>
or L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>.

=head1 AUTHOR

Jean Forget <JFORGET at cpan dot org>

=head1 THANKS

Many  thanks to  all those  who were  involved in  Perl 6,  Rakudo and
Rakudo-Star.

Many thanks  to Andrew,  Laurent and C<brian>  for writing  books that
helped me learn Perl 6.

And some additional thanks  to Andrew, whose C<Date::Converter> module
was the basis of the computations in this module.


=head1 COPYRIGHT AND LICENSE

Copyright © 2019, 2020 Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
