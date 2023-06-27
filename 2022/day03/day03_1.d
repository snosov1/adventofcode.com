import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;

void main(string[] args)
{
    stdin.byLine.map!(x => setIntersection(x[0..$/2].representation.sort,
                                           x[$/2..$].representation.sort).front)
         .map!(x => x <= 'Z' ? x - 'A' + 27 : x - 'a' + 1)
         .sum
         .writeln;
}
