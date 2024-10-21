#
# Checking the checks
#
use v6.c;
use Test;
use Date::Calendar::Hebrew;


my Date::Calendar::Hebrew $dt;

plan 17;

# tests on a normal year
dies-ok(  { $dt .= new(year => 5780, month => 14, day =>  3); }, "Month out of range");
lives-ok( { $dt .= new(year => 5780, month =>  4, day =>  3); }, "Month within range");
dies-ok(  { $dt .= new(year => 5780, month =>  0, day =>  3); }, "Month out of range");
dies-ok(  { $dt .= new(year => 5780, month => 13, day =>  3); }, "Month out of range for a normal year");
dies-ok(  { $dt .= new(year => 5780, month => 10, day => 33); }, "Day out of range");
dies-ok(  { $dt .= new(year => 5780, month => 10, day =>  0); }, "Day out of range");
lives-ok( { $dt .= new(year => 5780, month =>  5, day => 30); }, "Day within range");
lives-ok( { $dt .= new(year => 5780, month =>  4, day =>  1); }, "Day within range");
dies-ok(  { $dt .= new(year => 5780, month =>  4, day => 30); }, "Day out of range for this month");
# tests on a leap year
dies-ok(  { $dt .= new(year => 5779, month => 14, day =>  3); }, "Month out of range");
lives-ok( { $dt .= new(year => 5779, month => 13, day =>  3); }, "Month within range for a leap year");
dies-ok(  { $dt .= new(year => 5779, month =>  0, day =>  3); }, "Month out of range");
dies-ok(  { $dt .= new(year => 5779, month => 10, day => 33); }, "Day out of range");
dies-ok(  { $dt .= new(year => 5779, month => 10, day =>  0); }, "Day out of range");
lives-ok( { $dt .= new(year => 5779, month =>  5, day => 30); }, "Day within range");
lives-ok( { $dt .= new(year => 5779, month =>  4, day =>  1); }, "Day within range");
dies-ok(  { $dt .= new(year => 5779, month =>  4, day => 30); }, "Day out of range for this month");

