import std.stdio;
import std.conv;
import std.algorithm;
import std.range;
import std.array;
import std.format;
import std.datetime;
import std.uni;
import std.utf;
import std.typecons;
import std.math;

void main(string[] args)
{

    //recurrence!((a, n) => a[n-1] / 3 - 2)(1969).until!(x => x <= 0).writeln;

    stdin.byLine
         .map!(x => recurrence!((a, n) => a[n-1] / 3 - 2)(x.to!int / 3 - 2)
                    .until!(x => x <= 0)
                    .sum)
         .sum
         .writeln;
}
