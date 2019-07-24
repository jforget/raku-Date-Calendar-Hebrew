NAME
====

Date::Calendar::Hebrew - Conversions from / to the Hebrew calendar

SYNOPSIS
========

Converting a Gregorian date (e.g. 16th June 2019) into Hebrew

```perl6
use Date::Calendar::Hebrew;
my Date                   $TPC2019-Pittsburgh-grg .= new(2019, 6, 16);
my Date::Calendar::Hebrew $TPC2019-Pittsburgh-heb = new-from-date($TPC2019-Pittsburgh-grg);
say $TPC2019-Pittsburgh-heb; # --> 5779-03-13
say "{.day-name} {.day} {.month-name} {.year}" with $TPC2019-Pittsburgh-heb; # --> Yom Rishon 13 Sivan 5779

```

Converting a Hebrew date (e.g. 6 Av 5779) into Gregorian

```perl6
use Date::Calendar::Hebrew;
my Date::Calendar::Hebrew $Perlcon-Riga-heb = new(year  => 5779
                                                , month =>    5
                                                , day   =>    6);
my Date $Perlcon-Riga-grg = $Perlcon-Riga-heb.to-date;
say $Perlcon-Riga-grg;

```

INSTALLATION
============

```shell
zef install Date::Calendar::Hebrew
```

or

```shell
git clone https://github.com/jforget/p6-Date-Calendar-Hebrew.git
cd p6-Date-Calendar-Hebrew
zef install .
```


DESCRIPTION
===========

Date::Calendar::Hebrew  is a  class representing  dates in  the Hebrew
calendar. It allows  you to convert an Hebrew date  into Gregorian (or
possibly other) calendar and the other way.

AUTHOR
======

Jean Forget <JFORGET@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright © 2019 Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

