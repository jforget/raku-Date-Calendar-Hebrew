NAME
====

Date::Calendar::Hebrew - Conversions from / to the Hebrew calendar

SYNOPSIS
========

Converting a Gregorian date (e.g. 16th June 2019) into Hebrew

```
use Date::Calendar::Hebrew;
my Date                   $TPC2019-Pittsburgh-grg;
my Date::Calendar::Hebrew $TPC2019-Pittsburgh-heb;

$TPC2019-Pittsburgh-grg .= new(2019, 6, 16);
$TPC2019-Pittsburgh-heb .= new-from-date($TPC2019-Pittsburgh-grg);

say $TPC2019-Pittsburgh-heb;
# --> 5779-03-13
say "{.day-name} {.day} {.month-name} {.year}" with $TPC2019-Pittsburgh-heb;
# --> Yom Rishon 13 Sivan 5779

```

Converting a Hebrew date (e.g. 6 Av 5779) into Gregorian

```
use Date::Calendar::Hebrew;
my Date::Calendar::Hebrew $Perlcon-Riga-heb;
my Date                   $Perlcon-Riga-grg;

$Perlcon-Riga-heb .= new(year  => 5779
                       , month =>    5
                       , day   =>    6);
$Perlcon-Riga-grg = $Perlcon-Riga-heb.to-date;

say $Perlcon-Riga-grg;
```

Converting a Hebrew date to Gregorian, while paying attention to sunset.
For example, Hannukah begins on 25 Kislev at sunset. For 5785 / 2024,
what does that translate to in the Gregorian calendar?

```
use Date::Calendar::Hebrew;
use Date::Calendar::Strftime;
my Date::Calendar::Hebrew $hannukah-heb;
my Date                   $hannukah-grg;

$hannukah-heb .= new(year    => 5785
                   , month   =>    9
                   , day     =>   25
                   , daypart => after-sunset());
$hannukah-grg = $hannukah-heb.to-date;

say $hannukah-grg;
# --> '2024-12-25' instead of '2024-12-26'

# on the other hand:
$hannukah-heb .= new(year => 5785, month => 9, day => 25, daypart => before-sunrise());
$hannukah-grg  = $hannukah-heb.to-date;
say $hannukah-grg;
# --> '2024-12-26'

$hannukah-heb .= new(year => 5785, month => 9, day => 25, daypart => daylight());
$hannukah-grg  = $hannukah-heb.to-date;
say $hannukah-grg;
# --> '2024-12-26' also
```

INSTALLATION
============

```shell
zef install Date::Calendar::Hebrew
```

or

```shell
git clone https://github.com/jforget/raku-Date-Calendar-Hebrew.git
cd raku-Date-Calendar-Hebrew
zef install .
```

DESCRIPTION
===========

Date::Calendar::Hebrew  is a  class representing  dates in  the Hebrew
calendar. It allows  you to convert an Hebrew date  into Gregorian (or
possibly other) calendar and the other way.

when creating  the `Date::Calendar::xxxx` instance, you  may include a
`daypart` parameter, so the conversion will give the proper result for
dates after sunset.

AUTHOR
======

Jean Forget <J2N-FORGET at orange dot fr>

COPYRIGHT AND LICENSE
=====================

Copyright (c) 2019, 2020, 2023, 2024, 2025 Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

