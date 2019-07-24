use v6.c;
unit class Date::Calendar::Hebrew::Names:ver<0.0.2>:auth<cpan:JFORGET>;

my @month-names = <Nisan      Iyyar    Sivan
                   Tammuz     Av       Elul
                   Tishri     Sheshvan Kislev
                   Tevet      Shevat   Adar>
;
my @day-names = ( "Yom Rishon"
                , "Yom Sheni"
                , "Yom Shelishi"
                , "Yom Revil"
                , "Yom Hamishi"
                , "Yom Shishi"
                , "Shabbat"
);

our sub month-name(Int:D $month, Bool $leap = False --> Str) {
  if $leap && $month == 12 {
    return "Adar I";
  }
  if $leap && $month == 13 {
    return "Adar II";
  }
  return @month-names[$month - 1];
}

our sub day-name(Int:D $day7 --> Str) {
  return @day-names[$day7];
}


=begin pod

=head1 NAME

Date::Calendar::Hebrew::Names - string values for the Hebrew calendar

=head1 SYNOPSIS

=begin code :lang<perl6>

use Date::Calendar::Hebrew;

=end code

=head1 DESCRIPTION

Date::Calendar::Hebrew::Names is a utility module, providing
string values for the main module Date::Calendar::Hebrew.

=head1 SEE ALSO

=head2 Perl 5 Software

L<DateTime>

L<DateTime::Calendar::Hebrew>

L<Date::Convert>

L<Date::Hebrew::Simple>

L<Date::Converter>

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

=head1 COPYRIGHT AND LICENSE

Copyright © 2019 Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
