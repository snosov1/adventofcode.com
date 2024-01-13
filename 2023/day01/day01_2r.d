import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.ascii;
import std.regex;
import std.string;

enum d = [
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
    "1": 1,
    "2": 2,
    "3": 3,
    "4": 4,
    "5": 5,
    "6": 6,
    "7": 7,
    "8": 8,
    "9": 9,
    ];

auto fre = ctRegex!(d.keys.join('|'));
auto bre = ctRegex!(d.keys.map!(x => x.retro.to!string).join('|'));

void main(string[] args)
{
    stdin.byLineCopy
         .map!(x => 10 * d[x.matchFirst(fre).hit]
                       + d[x.retro.to!string.matchFirst(bre).hit.retro.to!string])
         .sum
         .writeln;
}
