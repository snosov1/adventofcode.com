import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;

void main(string[] args)
{
    stdin.byLineCopy
         .chunks(3)
         .map!(x => x.array)
         .map!(x => setIntersection(x[0].dup.representation.sort, x[1].dup.representation.sort, x[2].dup.representation.sort).front)
         .map!(x => x <= 'Z' ? x - 'A' + 27 : x - 'a' + 1)
         .sum
         .writeln;
}
