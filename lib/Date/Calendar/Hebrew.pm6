use v6.c;
use Date::Calendar::Hebrew::Names;
use List::MoreUtils <before>;

unit class Date::Calendar::Hebrew:ver<0.0.2>:auth<cpan:JFORGET>;

has Int $.year  where { $_ ≥ 1 };
has Int $.month where { 1 ≤ $_ ≤ 13 };
has Int $.day   where { 1 ≤ $_ ≤ 30 };

method gist {
  sprintf("%04d-%02d-%02d", $.year, $.month, $.day);
}

method month-name {
  Date::Calendar::Hebrew::Names::month-name($.month, $.is-leap);
}

method day-name {
  Date::Calendar::Hebrew::Names::day-name(($.daycount + 3) % 7);
}

method is-leap {
  is-leap($.year);
}

method daycount {
  ymdf-to-jed($.year, $.month, $.day) - mjd-to-jed();
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

# 29-day months: Iyyar, Tanmuz, Elul, Sheshvan (on 353, 354, 383 and 384-day years),
#                Kislev (on 353 and 383-day years), Tevet, Adar (when non leap) and Adar II (when leap)
# 30-day months: Nisan, Sivan, Av, Tishri, Sheshvan (on 355 and 385-day years),
#                Kislev (on 354, 355, 384 and 385-day years), Shevet and Adar I (when leap)
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
  # (I hope so, I have not checked the documentation). So with
  # thse two lines
  #      V ← 6 ⌽ ⍳ year_months year
  #      +/ { year month_days ⍵ } [ (¯1 + V ⍳ month) ↑ V ]
  # we get the number of days in the year before a given month.

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
  2019-04-06   5779-01-01 Shabbat 1 Nisan 5779 --> no change of year
  ...
  2019-09-29   5779-06-29 Yom Rishon 29 Elul 5779
  2019-09-30   5780-07-01 Yom Sheni 1 Tishri 5780 --> new year

=head1 METHODS

=head2 Constructors

=head3 new

Create an Hebrew date by giving the year, month and day numbers.

=head3 new-from-date

Build an  Hebrew date by  cloning an  object from another  class. This
other   class    can   be    the   core    class   C<Date>    or   any
C<Date::Calendar::xxx> class with a C<daycount> method.

=head3 new-from-daycount

Build an Hebrew date from the Modified Julian Day number.

=head2 Accessors

=head3 year, month, day

The numbers defining the date.

=head3 month-name

The month of the date, as a string.

=head3 day-name

The name of the day within  the week.

=head3 daycount

Convert the date to Modified Julian Day Number (a day-only scheme
based on 17 November 1858).

=head2 Other Methods

=head3 to-date

Clones  the   date  into   a  core  class   C<Date>  object   or  some
C<Date::Calendar::>R<xxx> compatible calendar  class. The target class
name is given  as a positional parameter. This  parameter is optional,
the default value is C<"Date"> for the Gregorian calendar.

To convert a date from a  calendar to another, you have two conversion
styles,  a "push"  conversion and  a "pull"  conversion. For  example,
while  converting  "26  Tammuz   5779"  to  the  French  Revolutionary
calendar, you can code:

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


=head1 PROBLEMS AND KNOWN BUGS

The  validation  of  C<new>  parameters  is  very  basic.  Especially,
checking the month  number ignores the year's nature  (leap or normal)
and you can create a date in Adar II for a normal year. Also, checking
the  day number  ignores the  month value  and you  can create  a 30th
Iyyar, a  30th Tammuz,  a 30th  Elul or  a 30th  Tevet, even  if these
months have only 29 days.

The  conversions are  valid before  sunset. It  is up  to the  user to
assert the  need of incrementing  the Hebrew date or  decrementing the
Gregorian date if the time of day is in the evening after sunset.

=head1 SEE ALSO

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

Copyright © 2019 Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
